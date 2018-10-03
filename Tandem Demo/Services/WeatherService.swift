//
//  LocationService.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 02.10.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeatherService {
    static let shared = WeatherService()
    
    let weatherDataModel = WeatherModel()
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "59a54878a35a9d6c822d56aac3cfd0a6"
    
    init() {}
    
    //MARK: - Getting weather data with current location
    func getWeatherData(lat: String, long: String, completion: ((_ temp: Int?, _ city: String?, _ iconName: String?) -> Void)? = nil) {
        let parameters = ["lat": lat, "lon": long, "appid": APP_ID]
        Alamofire.request(WEATHER_URL, method: .get, parameters: parameters).responseJSON { response in
            if response.result.isSuccess {
                print("Success, got weather data!")
                let weatherJSON: JSON = JSON(response.result.value!)
                self.convertWeatherData(json: weatherJSON, completion: { (temp, city, weatherIconName) in
                    guard let temp = temp else { return }
                    guard let city = city else { return }
                    guard let iconName = weatherIconName else { return }
                    completion!(temp, city, iconName)
                })
            } else {
                print("Error: \(response.result.error!)")
            }
        }
    }
    
    //MARK: - Parsing JSON
    func convertWeatherData(json: JSON, completion: (_ temp: Int?, _ city: String?, _ iconName: String?) -> Void) {
        if let temperatureResults = json["main"]["temp"].double {
            //Converting calvins to celcius
            weatherDataModel.temperature = Int(temperatureResults - 273.15)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
            let temp = weatherDataModel.temperature
            let city = weatherDataModel.city
            let weatherIconName = weatherDataModel.weatherIconName
            completion(temp, city, weatherIconName)
            print("City: \(city), temperature: \(temp), condition: \(weatherIconName)")
        } else {
            print("Weather unavaliable")
        }
    }
    
    //MARK: - Getting weather bu city name
    func cityWeatherUpdate(city: String, completion: @escaping (_ temp: Int?, _ city: String?, _ iconName: String?) -> Void) {
        //"q" is a required perameter name for city search in OpenWeatherMap API
        let parameters = ["q": city, "appid": APP_ID]
        Alamofire.request(WEATHER_URL, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                print("Success, got weather data for \(city)!")
                let weatherJSON: JSON = JSON(response.result.value!)
                self.convertWeatherData(json: weatherJSON, completion: { (temp, city, weatherIconName) in
                    guard let temp = temp else { return }
                    guard let city = city else { return }
                    guard let iconName = weatherIconName else { return }
                    completion(temp, city, iconName)
                })
            } else {
                print("Error: \(response.result.error!)")
            }
        }
    }
}
