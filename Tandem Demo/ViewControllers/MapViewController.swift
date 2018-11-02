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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationService.shared.delegate = self
        LocationService.shared.locationManager.stopUpdatingLocation()
        span.latitudeDelta = 0.07
        span.longitudeDelta = 0.07
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
    
    @IBAction func pinLocationGesture(_ sender: UILongPressGestureRecognizer) {
        let pinnedLocation = sender.location(in: mapView)
        let coordinates = mapView.convert(pinnedLocation, toCoordinateFrom: mapView)
        latitude = coordinates.latitude
        longitude = coordinates.longitude
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        mapView.addAnnotation(annotation)
        mapView.showAnnotations([annotation], animated: true)
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(latitude, longitude), span: span)
        //Get cuurent span 
        span = mapView.region.span
        mapView.setRegion(region, animated: true)
        
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
    
    @IBAction func submitButtonPressed(_ sender: Any) {
    }
}
