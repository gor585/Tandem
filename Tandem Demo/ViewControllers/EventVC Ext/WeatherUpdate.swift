//
//  WeatherUpdate.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 15.07.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import SVProgressHUD

extension EventsViewController {
    
    //MARK - LocationManager delegate methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Getting last (most accurate) location value of locations array
        let location = locations[locations.count - 1]
        //Stop updating location when valid location is received (horizontalAccuracy > 0)
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params: [String: String] = ["lat": latitude, "lon": longitude, "appid": APP_ID]
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error)")
        cityChangeButton.setTitle("Error", for: .normal)
    }
    
    //MARK: - Networking
    
    func getWeatherData(url: String, parameters: [String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            if response.result.isSuccess {
                print("Success, got weather data!")
                let weatherJSON: JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
            } else {
                print("Error: \(response.result.error!)")
                self.cityChangeButton.setTitle("Error", for: .normal)
            }
        }
    }
    
    //MARK: - JSON Parsing
    
    func updateWeatherData(json: JSON) {
        if let temperatureResults = json["main"]["temp"].double {
            //Converting calvins to celcius
            weatherDataModel.temperature = Int(temperatureResults - 273.15)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            print("City: \(weatherDataModel.city), temperature: \(weatherDataModel.temperature), condition: \(weatherDataModel.condition)")
            updateUIWithWeatherData()
        } else {
            print("Weather unavaliable")
        }
    }
    
    //MARK: - UI Updates
    
    func updateUIWithWeatherData() {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.center = cityChangeButton.center
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        cityChangeButton.addSubview(activityIndicator)
        
        if (Double(weatherDataModel.temperature) + 273.15) > 273.15 {
            temperatureLabel.text = "+\(weatherDataModel.temperature)°"
        } else if (Double(weatherDataModel.temperature) + 273.15) == 273.15 {
            temperatureLabel.text = "\(weatherDataModel.temperature)°"
        } else {
            temperatureLabel.text = "-\(weatherDataModel.temperature)°"
        }
        weatherIconImg.image = UIImage(named: weatherDataModel.weatherIconName)
        cityChangeButton.setTitle(weatherDataModel.city, for: .normal)
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    //MARK: - Change City Delegate Methods
    
//    func userEnteredNewCityName(city: String) {
//
//        //"q" is a required perameter name for city search in OpenWeatherMap API
//        let params: [String: String] = ["q": city, "appid": APP_ID]
//
//        getWeatherData(url: WEATHER_URL, parameters: params)
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if segue.identifier == "changeCity" {
//            let destinationVC = segue.destination as! ChangeCityViewController
//            destinationVC.delegate = self
//        }
//    }

}
