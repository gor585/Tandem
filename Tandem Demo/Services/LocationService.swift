//
//  LocationService.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 03.10.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase

class LocationService: NSObject, CLLocationManagerDelegate {
    static let shared = LocationService()
    
    let locationManager = CLLocationManager()
    
    var delegate: LocationData?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    //MARK - LocationManager delegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Getting last (most accurate) location value of locations array
        let location = locations[locations.count - 1]
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                //Stop updating location when valid location is received (horizontalAccuracy > 0)
                if location.horizontalAccuracy > 0 {
                    self.locationManager.stopUpdatingLocation()
                    print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")

                    let latitude = String(location.coordinate.latitude)
                    let longitude = String(location.coordinate.longitude)

                    //Passing location data to delegate
                    self.delegate?.getLocationData(lat: latitude, long: longitude)
                } else {
                    self.locationManager.stopUpdatingLocation()
                    self.locationManager.delegate = nil
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error)")
    }
}
