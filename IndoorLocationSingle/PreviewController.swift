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

class PreviewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate, UISearchDisplayDelegate{
    
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
    var obj : CellClass = CellClass(uni: "", campus: "", _class: "", building: "", room: "", name: "")
    var classList: [CellClass] = []
    var locationManager = CLLocationManager()
   
    //Map
    let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: GMSCameraPosition.camera(withLatitude: 33.937627809267894, longitude: -84.52016282826662, zoom: 60.0))


    override func viewDidLoad() {
        super.viewDidLoad()
        //Show Selected Class Values
        University?.text = obj.university
        Campus?.text = obj.campus
        Class?.text = obj._class
        Building?.text = obj.building
        Room?.text = obj.room
        Name?.text = obj.name
        
        //TEST
        
        
        
        //Places Search API
        /*
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self as! GMSAutocompleteResultsViewControllerDelegate
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        let subView = UIView(frame: CGRect(x: 0, y: 45.0, width: 350.0, height: 45.0))
        
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
 */
        
      
    }
    
    @IBAction func Back(_ sender: Any) {
        performSegue(withIdentifier: "back", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Hold Values of List
        let vc = segue.destination as! ViewController
        
        vc.classList = self.classList
    }
 
    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        
        self.view = mapView
        
        //TODO: ARRAY LIST FOR EACH FLOOR; ROOM NUMBERS
        //TODO: TABLEVIEW/MAPVIEW IN SAME VIEW. ROUTE TO DIFFERENT CLASS
        //TODO: TOP 80% MAP; BOTTOM 20% CLASSLIST. INFO DISPLAYED: COLOR, CLASS NAME, ROOM NUMBER
        //TURN TABLEROWS MARKERS IN BOTTOM 20% CLASSLIST TOGGLE (OPACITY CHANGE 1 TO .5)
        //TODO: FORM: PRESET UNI-KENNESAW, CAMPUS-MARIETTA, BUILDING-ATRIUM
        
        
        
        
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 33.937627809267894, longitude: -84.52016282826662)
        marker.title = "Kennesaw"
        marker.snippet = "Georgia"
        //TODO: Change Map color
        marker.map = mapView
        
        
        //Creating Circle
        /*
        let circleCenter = CLLocationCoordinate2D(latitude: 34.038, longitude: -84.5816)
        let circ = GMSCircle(position: circleCenter, radius: 500)
        circ.fillColor = UIColor(red: 0, green: 0, blue: 1.0, alpha: 0.05)
        circ.strokeColor = .blue
        circ.strokeWidth = 5
        circ.map = mapView
 */
        
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
        marker.title = "Kennesaw"
        marker.snippet = "Georgia"
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
}

