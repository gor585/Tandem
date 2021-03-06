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
            if error == nil {
                guard let place = placemarks?.first else { return }
                //Full placemark address
                let address = String(describing: place)
                //Address components
                let name = placemarks?.first?.name
                let buildingNumber = placemarks?.first?.subThoroughfare
                let street = placemarks?.first?.thoroughfare
                let city = placemarks?.first?.locality
                let region = placemarks?.first?.administrativeArea
                let country = placemarks?.first?.country
                addressDict.updateValue(address, forKey: "address")
                addressDict.updateValue(name ?? "", forKey: "name")
                addressDict.updateValue(buildingNumber ?? "", forKey: "buildingNumber")
                addressDict.updateValue(street ?? "", forKey: "street")
                addressDict.updateValue(city ?? "", forKey: "city")
                addressDict.updateValue(region ?? "", forKey: "region")
                addressDict.updateValue(country ?? "", forKey: "country")
                completion(addressDict)
            } else {
                print("Reverse geocoding error: \(error!.localizedDescription)")
            }
        }
    }
    
    func getDistance(currentLocation: CLLocation, eventLocation: CLLocation, completion: (Double?) -> Void) {
        let distanceInMeters = eventLocation.distance(from: currentLocation)
        let distanceInKilometers = Double(round(distanceInMeters) / 1000)
        completion(distanceInKilometers)
    }
}
