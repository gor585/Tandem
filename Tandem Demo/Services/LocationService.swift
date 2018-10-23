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
    
    func reverseGeocoding(lat: Double, long: Double, completion: @escaping (_ addressDict: [String: String]?) -> Void) {
        var addressDict = [String: String]()
        let location = CLLocation(latitude: lat, longitude: long)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let buildingNumber = placemarks?.first?.subThoroughfare else { return }
            guard let street = placemarks?.first?.thoroughfare else { return }
            guard let city = placemarks?.first?.locality else { return }
            guard let region = placemarks?.first?.administrativeArea else { return }
            guard let country = placemarks?.first?.country else { return }
            addressDict.updateValue(buildingNumber, forKey: "buildingNumber")
            addressDict.updateValue(street, forKey: "street")
            addressDict.updateValue(city, forKey: "city")
            addressDict.updateValue(region, forKey: "region")
            addressDict.updateValue(country, forKey: "country")
            completion(addressDict)
        }
    }
}
