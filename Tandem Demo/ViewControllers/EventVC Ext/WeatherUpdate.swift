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

extension EventsViewController {
    
    func getWeatherData(url: String, parameters: [String: String]) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success, got data!")
                
                let weatherJSON: JSON = JSON(response.result.value!)
                
                self.updateWeatherData(json: weatherJSON)
                
            } else {
                print("Error: \(response.result.error!)")
            }
        }
    }
    
    func updateWeatherData(json: JSON) {
        
        if let tempResults = json["main"]["temp"].double {
            //Converting calvins to celcius
            weatherDataModel.temperature = Int(tempResults - 273.15)
            
            weatherDataModel.city = json["name"].stringValue
            
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            print("Condition: \(weatherDataModel.condition)")
            
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
            updateUIWithWeatherData()
            
        } else {
            print("Weather Unavaliable")
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Getting last (most accurate) location value of locations array
        let location = locations[locations.count - 1]
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
    }
    
    
    //MARK: - UI Updates
    
    func updateUIWithWeatherData() {
        
        temperatureLabel.text = "\(weatherDataModel.temperature)°"
        weatherIconImg.image = UIImage(named: weatherDataModel.weatherIconName)
        cityChangeButton.titleLabel!.text = weatherDataModel.city
        
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
