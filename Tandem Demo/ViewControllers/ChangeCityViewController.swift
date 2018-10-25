//
//  ChangeCityViewController.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 04.09.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit
import MapKit

class ChangeCityViewController: UIViewController {
    
    @IBOutlet weak var enterCityNameLabel: UILabel!
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    var delegate: ChangeCityName?
    var lightColorTheme = Bool()
    var currentCityName: String?
    var latitude = 0.0
    var longitude = 0.0
    
    var region = MKCoordinateRegion()
    var span = MKCoordinateSpan()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyColorTheme()
        mapView.delegate = self
        LocationService.shared.delegate = self
        LocationService.shared.locationManager.startUpdatingLocation()
        
        span.latitudeDelta = 0.5
        span.longitudeDelta = 0.5
    }
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        if cityNameTextField.text == "" {
            let alert = UIAlertController(title: "No city name provided", message: "Please enter city name", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Ok", style: .default, handler: { (action) in })
            alert.addAction(actionOk)
            present(alert, animated: true, completion: nil)
        } else {
            guard let city = cityNameTextField.text else { return }
            delegate?.userChangedCityName(cityName: city)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func applyColorTheme() {
        switch lightColorTheme {
        case true:
            self.view.backgroundColor = UIColor(hexString: "E6E6E6")
            enterCityNameLabel.textColor = UIColor(hexString: "008080")
        case false:
            self.view.backgroundColor = UIColor(hexString: "7F7F7F")
            enterCityNameLabel.textColor = UIColor.white
        break
        }
    }
}

//MARK: - Location & MapKit delegate methods
extension ChangeCityViewController: MKMapViewDelegate, LocationData {
    func getLocationData(lat: String, long: String) {
        guard let lat = Double(lat) else { return }
        guard let long = Double(long) else { return }
        latitude = lat
        longitude = long
        updateMap()
    }
    
    func updateMap() {
        region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(latitude, longitude), span)
        
        mapView.centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude)
        mapView.showsUserLocation = true
        mapView.setRegion(region, animated: true)
        
        LocationService.shared.reverseGeocoding(lat: latitude, long: longitude) { (address) in
            guard let addressDict = address else { return }
            let address = addressDict["address"]
            print("Received address: \(address)")
            DispatchQueue.main.async {
                if address != nil && address != "" {
                    self.addressLabel.text = "Location: \(address!))"
                } else {
                    self.addressLabel.text = "Location is unavailable"
                }
            }
        }
    }
}
