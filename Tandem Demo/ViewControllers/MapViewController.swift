//
//  MapViewController.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 02.11.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, LocationData {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    var latitude = 0.0
    var longitude = 0.0
    var location = ""
    var usersCurrentLatitude = 0.0
    var usersCurrentLongitude = 0.0
    var span = MKCoordinateSpan()
    
    var delegate: ItemCoordinates?
    var id = ""
    var isInEditingMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationService.shared.delegate = self
        LocationService.shared.locationManager.stopUpdatingLocation()
        span.latitudeDelta = 0.07
        span.longitudeDelta = 0.07
        if isInEditingMode == true {
            setUpMapForEditing(latitude: latitude, longitude: longitude)
        }
    }
    
    func getLocationData(lat: String, long: String) {
        guard let lat = Double(lat) else { return }
        guard let long = Double(long) else { return }
        usersCurrentLatitude = lat
        usersCurrentLongitude = long
        setUpMapView()
    }
    
    func setUpMapView() {
        let usersLocationDisplay = CLLocationCoordinate2DMake(usersCurrentLatitude, usersCurrentLongitude)
        let region = MKCoordinateRegion(center: usersLocationDisplay, span: span)
        mapView.centerCoordinate = usersLocationDisplay
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
    
    func setUpMapForEditing(latitude: Double, longitude: Double) {
        let eventLocationDisplay = CLLocationCoordinate2DMake(latitude, longitude)
        let region = MKCoordinateRegion(center: eventLocationDisplay, span: span)
        mapView.centerCoordinate = eventLocationDisplay
        addAnnotation(coordinates: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        
        reverseGeocoding(latitude: latitude, longitude: longitude)
    }
    
    @IBAction func pinLocationGesture(_ sender: UILongPressGestureRecognizer) {
        let pinnedLocation = sender.location(in: mapView)
        let coordinates = mapView.convert(pinnedLocation, toCoordinateFrom: mapView)
        latitude = coordinates.latitude
        longitude = coordinates.longitude
        
        addAnnotation(coordinates: coordinates)
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(latitude, longitude), span: span)
        //Get current span 
        span = mapView.region.span
        mapView.setRegion(region, animated: true)
        
        reverseGeocoding(latitude: latitude, longitude: longitude)
    }
    
    func reverseGeocoding(latitude: Double, longitude: Double) {
        LocationService.shared.reverseGeocoding(lat: latitude, long: longitude) { (address) in
            guard let addressDict = address else { print("no dict"); return }
            let address = addressDict["address"]
            DispatchQueue.main.async {
                if address != nil && address != "" {
                    self.location = address!
                    self.addressLabel.text = "Location: \(self.location))"
                } else {
                    self.addressLabel.text = "Location is unavailable"
                }
            }
        }
    }
    
    func addAnnotation(coordinates: CLLocationCoordinate2D) {
        //Remove all previous annotations to display only the latest pin
        mapView.removeAnnotations(mapView.annotations)
        //Create new annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        mapView.addAnnotation(annotation)
        mapView.showAnnotations([annotation], animated: true)
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        let lat = String(latitude)
        let long = String(longitude)
        guard let address = addressLabel.text else { return }
        delegate?.itemCoordinates(latitude: lat, longitude: long, address: address)
        
        //Loading new location data if map is in Editing Mode
        if isInEditingMode == true {
            DataService.shared.editItemLocationProperties(id: id, latitude: lat, longitude: long, completion: {})
        }
        
        self.navigationController?.popViewController(animated: true)
    }
}
