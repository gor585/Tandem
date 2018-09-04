//
//  ChangeCity.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 04.09.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit
import CoreLocation

extension EventsViewController: ChangeCityName {
    
    //MARK: - Change City Delegate Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let changeCityNameVC = segue.destination as! ChangeCityViewController
            changeCityNameVC.lightColorTheme = lightColorTheme
            changeCityNameVC.delegate = self
        }
    }
    
    func userChangedCityName(cityName: String) {
        cityChangeButton.setTitle(cityName, for: .normal)
        //"q" is a required perameter name for city search in OpenWeatherMap API
        let params: [String: String] = ["q": cityName, "appid": APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
}
