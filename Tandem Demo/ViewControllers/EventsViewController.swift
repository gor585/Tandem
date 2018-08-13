//
//  EventsViewController.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 07.07.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit
import CoreLocation

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var weatherIconImg: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityChangeButton: UIButton!
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "59a54878a35a9d6c822d56aac3cfd0a6"
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    var eventArray = [Event]()
    
    let planetaKino = Event(title: "Planeta Kino", image: UIImage(named: "planetaKino")!, url: "https://planetakino.ua/lvov2/showtimes/#imax_4dx_relux_cinetech_vr_2d_3d_one-day")
    let kinopalace = Event(title: "Kinopalace",image: UIImage(named: "kinopalace-logo")!, url: "http://kinopalace.lviv.ua/schedule/")
    let lesya = Event(title: "Teatr Lesi",image: UIImage(named: "teatr-lesi")!, url: "http://teatrlesi.lviv.ua/events/")
    let kurbas = Event(title: "Teatr Kurbasa",image: UIImage(named: "kurbas-1")!, url: "http://www.kurbas.lviv.ua/afisha/")
    let philarmony = Event(title: "Philarmony",image: UIImage(named: "philarmony")!, url: "https://philharmonia.lviv.ua/events/")
    
    let userDefaults = UserDefaults.standard
    var lightColorTheme: Bool = true
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        createObservers()
        
        eventArray.append(planetaKino)
        eventArray.append(kinopalace)
        eventArray.append(lesya)
        eventArray.append(kurbas)
        eventArray.append(philarmony)
        
        cityChangeButton.layer.cornerRadius = 15
        
        lightColorTheme = userDefaults.bool(forKey: "lightThemeIsOn")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! EventCell
        //Applying selected color theme
        applyColorTheme(cell: cell)
        cell.eventImage?.image = eventArray[indexPath.row].image
        cell.eventTitleLabel.text = eventArray[indexPath.row].title
        cell.eventItemView.layer.cornerRadius = 15
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: eventArray[indexPath.row].url!) else { return }
        UIApplication.shared.open(url as URL)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    @IBAction func cityChangeButtonPressed(_ sender: Any) {
    }
}
