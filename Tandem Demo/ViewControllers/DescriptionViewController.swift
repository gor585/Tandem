//
//  DescriptionViewController.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 24.10.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit
import MapKit

class DescriptionViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var eventIcon: UIImageView!
    @IBOutlet weak var pathButton: UIButton!
    
    var event: Event?
    var usersCurrentLatitude = 0.0
    var usersCurrentLongitude = 0.0
    var lightColorTheme = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyColorTheme()
        mapView.delegate = self
        LocationService.shared.delegate = self
        LocationService.shared.locationManager.startUpdatingLocation()
        setUpEvent()
        pathButton.layer.cornerRadius = 15
    }
    
    func applyColorTheme() {
        switch lightColorTheme {
        case true:
            self.view.backgroundColor = UIColor(hexString: "E6E6E6")
            titleLabel.textColor = UIColor(hexString: "800000")
            startLabel.textColor = UIColor(hexString: "008080")
            endLabel.textColor = UIColor(hexString: "008080")
            addressLabel.textColor = UIColor(hexString: "008080")
            distanceLabel.textColor = UIColor(hexString: "800000")
            descriptionTextView.backgroundColor = UIColor(hexString: "E6E6E6")
            descriptionTextView.textColor = UIColor.black
            pathButton.backgroundColor = UIColor(hexString: "800000")
        case false:
            self.view.backgroundColor = UIColor(hexString: "7F7F7F")
            titleLabel.textColor = UIColor(hexString: "FFCC66")
            startLabel.textColor = UIColor.white
            endLabel.textColor = UIColor.white
            addressLabel.textColor = UIColor.white
            distanceLabel.textColor = UIColor(hexString: "FFCC66")
            descriptionTextView.backgroundColor = UIColor(hexString: "7F7F7F")
            descriptionTextView.textColor = UIColor.white
            pathButton.backgroundColor = UIColor(hexString: "FFCC66")
            break
        }
    }
    
    //MARK: - Event info setup
    func setUpEvent() {
        guard let title = event?.title else { return }
        guard let start = event?.start else { return }
        guard let end = event?.end else { return }
        guard let icon = UIImage(named: (event?.category)!) else { return }
        guard let description = event?.description else { return }
        
        titleLabel.text = title
        startLabel.text = "Start: \(start)"
        endLabel.text = "End: \(end)"
        eventIcon.image = icon
        descriptionTextView.text = description
    }
    
    //MARK: - MapView setup
    func setUpMapView() {
        guard let lat = event?.lat else { return }
        guard let long = event?.long else { return }
        guard let latitude = Double(lat) else { return }
        guard let longitude = Double(long) else { return }
        let eventLocationDisplay = CLLocationCoordinate2DMake(latitude, longitude)
        
        var span = MKCoordinateSpan()
        span.latitudeDelta = 0.07
        span.longitudeDelta = 0.07
        let region = MKCoordinateRegionMake(eventLocationDisplay, span)
        
        //Mark event location
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        //Get distance value from current location to event location
        let currentUsersLocation = CLLocation(latitude: usersCurrentLatitude, longitude: usersCurrentLongitude)
        let eventLocation = CLLocation(latitude: latitude, longitude: longitude)
        LocationService.shared.getDistance(currentLocation: currentUsersLocation, eventLocation: eventLocation) { (distance) in
            guard let distance = distance else { return }
            self.distanceLabel.text = "Distance to event: \(distance)km"
        }
        
        mapView.centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude)
        mapView.showsUserLocation = true
        mapView.addAnnotation(annotation)
        mapView.showAnnotations([annotation], animated: true)
        mapView.setRegion(region, animated: true)
        
        LocationService.shared.reverseGeocoding(lat: latitude, long: longitude) { (address) in
            guard let addressDict = address else { print("no dict"); return }
            let address = addressDict["address"]
            DispatchQueue.main.async {
                if address != nil && address != "" {
                    self.addressLabel.text = "Location: \(address!))"
                } else {
                    self.addressLabel.text = "Location is unavailable"
                }
            }
        }
    }
    
    //MARK: - Detailed Map Navigation
    @IBAction func pathButtonPressed(_ sender: Any) {
        guard let lat = event?.lat else { return }
        guard let long = event?.long else { return }
        guard let eventLatitude = Double(lat) else { return }
        guard let eventLongitude = Double(long) else { return }
        let eventCoordinates = CLLocationCoordinate2DMake(eventLatitude, eventLongitude)
        let regionDistance: CLLocationDistance = 1000
        let regionSpan = MKCoordinateRegionMakeWithDistance(eventCoordinates, regionDistance, regionDistance)
        let options = [MKLaunchOptionsMapCenterKey: regionSpan.center, MKLaunchOptionsMapSpanKey: regionSpan.span] as [String: Any]
        let placemark = MKPlacemark(coordinate: eventCoordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "\(event?.title ?? "Event")"
        mapItem.openInMaps(launchOptions: options)
    }
}

//MARK: - Location Data delegate methods
extension DescriptionViewController: MKMapViewDelegate, LocationData {
    func getLocationData(lat: String, long: String) {
        guard let lat = Double(lat) else { return }
        guard let long = Double(long) else { return }
        usersCurrentLatitude = lat
        usersCurrentLongitude = long
        setUpMapView()
    }
}
