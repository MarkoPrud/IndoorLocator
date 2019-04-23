//
//  PreviewController.swift
//  IndoorLocationSingle
//
//  Created by SamanthaLauren on 4/6/19.
//  Copyright © 2019 Colby Schueller. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON

class PreviewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GMSMapViewDelegate,GMSIndoorDisplayDelegate, CLLocationManagerDelegate, UISearchDisplayDelegate{
    
    //Places API
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    @IBOutlet weak var University: UILabel!
    @IBOutlet weak var Campus: UILabel!
    @IBOutlet weak var Class: UILabel!
    @IBOutlet weak var Building: UILabel!
    @IBOutlet weak var Room: UILabel!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var UIMapView: UIView!
    @IBOutlet weak var ClassTableView: UITableView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var tableLabel: UIView!
    //Custom Classes and Data Transfers
    var obj : CellClass = CellClass(uni: "", campus: "", _class: "", building: "", room: "", name: "", coordinates: [0,0])
    var classList: [CellClass] = []
    var locationManager = CLLocationManager()
    var mapView: GMSMapView!
    // cell reuse id (cells that scroll out of view can be reused)
    let identifier = "cell"
    
    //Keep Track of Markers
    //[floor] = [MarkerName : GMSMarker]
    var markers =  [[Int] : GMSMarker]()

    //Origin and Destination calculation
    var origin = CLLocationCoordinate2D(latitude: 33.953228120476346, longitude: -84.51008275151253)
    var destination = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TableView Delegates and DataSource
        self.ClassTableView.register(ClassCellPrototype.self, forCellReuseIdentifier: identifier)
        ClassTableView.delegate = self
        ClassTableView.dataSource = self
        
        //Show Selected Class Values
        University?.text = obj.university
        Campus?.text = obj.campus
        Class?.text = obj._class
        Building?.text = obj.building
        Room?.text = obj.room
        Name?.text = obj.name
        
        
        //UIView Frames
        let recMap = CGRect(x:0,y:65,width:self.view.frame.width,height: self.view.frame.height/2 + 50)
        let recLabel = CGRect(x: 0, y: self.view.frame.height/2 + 115, width: self.view.frame.width, height: 30)
        
        let recTable = CGRect(x:0,y:self.view.frame.height/2 + 135
            ,width:self.view.frame.width,height: self.view.frame.height/2)
        
        //UIViews & TableView Styling
        UIMapView.frame = recMap
        ClassTableView.frame = recTable
        ClassTableView.backgroundColor = UIColor.clear
      
        tableLabel.frame = recLabel
        tableLabel.backgroundColor = UIColor.clear
        
        //Map
        mapView = GMSMapView.map(withFrame: UIMapView.frame, camera: GMSCameraPosition.camera(withLatitude: 33.937627809267894, longitude: -84.52016282826662, zoom: 18.5))
        UIMapView = mapView
        
        self.view.addSubview(UIMapView)
        self.view.addSubview(ClassTableView)
       
        
        //GMS Events
        mapView.delegate = self
        mapView.settings.indoorPicker = true
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.delegate = self
        mapView.indoorDisplay.delegate = self
        
        //Location Services
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
        if let mylocation = mapView.myLocation {
            print("User's location: \(mylocation)")
        } else {
            print("User's location is unknown")
        }
        
       
    }
    
    @IBAction func Back(_ sender: Any) {
        performSegue(withIdentifier: "back", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Hold Values of List
        let vc = segue.destination as! ViewController
        
        vc.classList = self.classList
    }
 
    
 
    //Location Manager delegates
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        self.origin = CLLocationCoordinate2D(latitude: ((location?.coordinate.latitude ?? nil)!)!, longitude: ((location?.coordinate.longitude ?? nil)!)!)
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude ?? nil)!, longitude: (location?.coordinate.longitude ?? nil)!, zoom: 17.0)
        self.mapView.animate(to: camera)
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }
    // MARK: GMSMapViewDelegate
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        marker.title = "Test"
        marker.snippet = "Marker"
        
        //TODO: Change Map color
        marker.map = mapView
    }
    
  
}
extension PreviewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(String(describing: place.name))")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.classList.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Custom Rectangle

        //Custom Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ClassCellPrototype
        cell.backgroundColor = nil
        
        let obj = ClassObject.init(ClassName: self.classList[indexPath.row].name, MarkerColor: .random(), RoomNumber: self.classList[indexPath.row].room, Longitude: 0.0, Latitude: 0.0, Markers: self.markers, Row: indexPath.row)
      
        //Creates Marker for each Row
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: self.classList[indexPath.row].coordinates[0], longitude: self.classList[indexPath.row].coordinates[1])
        marker.title = obj.ClassName
        marker.snippet = obj.RoomNumber
        marker.icon = GMSMarker.markerImage(with: obj.MarkerColor)
        
        //Checks to see if the marker already exists
        if (markers[[1, indexPath.row]] == nil){
            marker.map = mapView
           
            cell.backgroundColor = UIColor.clear
            cell.layer.backgroundColor = UIColor.clear.cgColor
            cell.product = obj

        }
        
        //Keeping Track Of Markers
        if (obj.RoomNumber.first == "1"){
            //Add Marker to ArrayList
            if (markers[[1, indexPath.row]] == nil){
                markers[[1 , indexPath.row]] = marker

            }
            print("Marker Added At: Floor 1 ; \(String(describing: indexPath.row)) ; \(String(describing: markers[[1, indexPath.row]]?.position))")

        }
        else{
            //markers[2]?[indexPath.row] = marker
        }
       
        //Creating Prototpe cell

        
        
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("You tapped cell number \(indexPath.row).")
        self.destination = ((markers[[1, indexPath.row]]?.position ?? nil) ?? nil)!
        
        //draws the path to that location
        //drawPath(startLocation: origin, endLocation: destination)

        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            UIApplication.shared.openURL(URL(string:
                "comgooglemaps://?saddr=&daddr=\(destination.latitude)),\(destination.longitude)&directionsmode=walking")!)
        } else {
            print("Can't use comgooglemaps://");
        }
        
        
        
        //tableView.cellForRow(at: indexPath)
        //classList.remove(at: indexPath.row)
        //tableView.reloadData()
    }
    @objc func switchChanged(mySwitch: UISwitch) {
        let temp = mySwitch.isOn
        
        // Do something
        if temp {
            self.markers[[1, mySwitch.tag]]?.map = mapView

            //print("Marker On: Floor 1 ; \(String(describing: mySwitch.tag)) ; \(String(describing: marker.position))")
        }
        else{
      
            self.markers[[1, mySwitch.tag]]?.map = nil
            //print("Marker Off: Floor 1 ; \(String(describing: mySwitch.tag)) ; \(String(describing: marker.position))")

        }
        
    }
    
    //Floor Manager Delegate
    
    func didChangeActiveBuilding(building: GMSIndoorBuilding!) {
        if let currentBuilding = building {
            var levels = currentBuilding.levels
            mapView.indoorDisplay.activeLevel = levels[2] // set the level (key)
        }
    }
    
    func didChangeActiveLevel(level: GMSIndoorLevel!) {
        print("will be called after activeBuilding \(String(describing: level))")
    }
    func drawPath(startLocation: CLLocationCoordinate2D, endLocation: CLLocationCoordinate2D){

        let origin = "\(startLocation.latitude),\(startLocation.longitude)"
        let destination = "\(endLocation.latitude),\(endLocation.longitude)"
        print("\(destination) : \(origin)")
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&key=AIzaSyDG-8PrJloQHG-pMJwrvJHEwr196RkhuMA"
        Alamofire.request(url).validate
            { request, response, data in
            // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
            //print("response", response);
            return .success
            }
            .responseJSON(completionHandler: { (response) in
                guard response.result.value != nil else { return }
            let json = JSON(response.data!)

            print(response.request as Any)
            print(response.response as Any)
            print(response.data as Any)
            
            let routes = json["routes"].arrayValue
            
            for route in routes{
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 4
                polyline.strokeColor = UIColor.blue
                polyline.map = self.mapView
            }
            })
    }
    //Prototype Cell
    class ClassCellPrototype : UITableViewCell {
        var product : ClassObject? {
            didSet {
                classNameLabel.text = product?.ClassName
                classFloorLabel.text = (product?.RoomNumber)
                classRoomNumber.text = product?.RoomNumber
                classSwitch.onTintColor = product?.MarkerColor
                classColor.backgroundColor = product?.MarkerColor
                classSwitch.tag = product?.Row ?? 3000
                
                
            }
        }
        
        private let classColor : UIImageView = {
            
            let imgView = UIImageView()
            imgView.frame.size.height = 20
            imgView.frame.size.width = 20
            imgView.layer.borderColor = UIColor.blue.cgColor
            
            return imgView
        }()
        private let classNameLabel : UILabel = {
            let lbl = UILabel()
            lbl.textColor = UIColor.lightGray
            lbl.font = UIFont.systemFont(ofSize: 13)
            lbl.textAlignment = .left
            return lbl
        }()
        
        private let classFloorLabel : UILabel = {
            let lbl = UILabel()
            lbl.textColor = UIColor.lightGray
            lbl.font = UIFont.systemFont(ofSize: 12)
            lbl.textAlignment = .left
            lbl.numberOfLines = 0
            return lbl
        }()
        private let classRoomNumber : UILabel = {
            let lbl = UILabel()
            lbl.textColor = UIColor.lightGray
            lbl.font = UIFont.systemFont(ofSize: 12)
            lbl.textAlignment = .left
            lbl.numberOfLines = 0
            return lbl
        }()
        
        private let classSwitch : UISwitch = {
            let turnOnandOff = UISwitch()
            turnOnandOff.isOn = true
            turnOnandOff.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
            return turnOnandOff
        }()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            addSubview(classNameLabel)
            addSubview(classFloorLabel)
            addSubview(classRoomNumber)
            addSubview(classSwitch)
            
            
            classNameLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 27, paddingLeft: 10, paddingBottom: 20, paddingRight: 0, width: frame.size.width / 2, height: 0, enableInsets: false)
            classFloorLabel.anchor(top: topAnchor, left: classNameLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 27, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width / 6, height: 0, enableInsets: false)
             classRoomNumber.anchor(top: topAnchor, left: classFloorLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 27, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: frame.size.width / 6, height: 0, enableInsets: false)
            classSwitch.anchor(top: topAnchor, left: classRoomNumber.rightAnchor, bottom: nil, right: nil, paddingTop: 18, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width / 6, height: 0, enableInsets: false)
            
            
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
    }
    
    
}
extension UIImage {
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}


