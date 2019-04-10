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

class PreviewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GMSMapViewDelegate, CLLocationManagerDelegate, UISearchDisplayDelegate{
    
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
    
    var obj : CellClass = CellClass(uni: "", campus: "", _class: "", building: "", room: "", name: "", coordinates: [0,0])
    var classList: [CellClass] = []
    var locationManager = CLLocationManager()
    var mapView: GMSMapView!
    // cell reuse id (cells that scroll out of view can be reused)
    let identifier = "cell"
    
    //Keep Track of Markers
    var markers: [GMSMarker] = []

    
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
        let recMap = CGRect(x:0,y:65,width:self.view.frame.width,height: self.view.frame.height/2 + self.view.frame.height/5)
        let recTable = CGRect(x:0,y:self.view.frame.height/2 + self.view.frame.height/5,width:self.view.frame.width,height: self.view.frame.height/5)
        
        //UIViews
        UIMapView.frame = recMap
        ClassTableView.frame = recTable
        
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
    
    //TABLE VIEW
    
    
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.classList.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Custom Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ClassCellPrototype
        
        let obj = ClassObject.init(ClassName: self.classList[indexPath.row].name, MarkerColor: .random(), RoomNumber: self.classList[indexPath.row].room, Longitude: 0.0, Latitude: 0.0)
      
        //Creates Marker for each Row
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: self.classList[indexPath.row].coordinates[0], longitude: self.classList[indexPath.row].coordinates[1])
        marker.title = obj.ClassName
        marker.snippet = obj.RoomNumber
        marker.icon = GMSMarker.markerImage(with: obj.MarkerColor)
        marker.map = mapView
        
        
        //Add Marker to List
        markers.append(marker)
        
        cell.product = obj
        
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("You tapped cell number \(indexPath.row).")
        
        tableView.cellForRow(at: indexPath)
        //classList.remove(at: indexPath.row)
        //tableView.reloadData()
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

