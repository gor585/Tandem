//
//  LocationService.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 03.10.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import Foundation
import CoreLocation

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
        
        //Stop updating location when valid location is received (horizontalAccuracy > 0)
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            //Passing location data to delegate
            delegate?.getLocationData(lat: latitude, long: longitude)
        } else {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error)")
    }
}
