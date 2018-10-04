//
//  EventsViewController.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 07.07.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LocationData {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var weatherIconImg: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityChangeButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var eventArray = [Event]()
    
    let planetaKino = Event(title: "Planeta Kino", image: UIImage(named: "planetaKino")!, url: "https://planetakino.ua/lvov2/showtimes/#imax_4dx_relux_cinetech_vr_2d_3d_one-day")
    let kinopalace = Event(title: "Kinopalace",image: UIImage(named: "kinopalace-logo")!, url: "http://kinopalace.lviv.ua/schedule/")
    let lesya = Event(title: "Teatr Lesi",image: UIImage(named: "teatr-lesi")!, url: "http://teatrlesi.lviv.ua/events/")
    let kurbas = Event(title: "Teatr Kurbasa",image: UIImage(named: "kurbas-1")!, url: "http://www.kurbas.lviv.ua/afisha/")
    let philarmony = Event(title: "Philarmony",image: UIImage(named: "philarmony")!, url: "https://philharmonia.lviv.ua/events/")
    
    let userDefaults = UserDefaults.standard
    var lightColorTheme = Bool()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        print("EV VC LOADED")
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        //Getting location for weather update
        LocationService.shared.delegate = self
        LocationService.shared.locationManager.startUpdatingLocation()
        
        eventArray.append(planetaKino)
        eventArray.append(kinopalace)
        eventArray.append(lesya)
        eventArray.append(kurbas)
        eventArray.append(philarmony)
        
        activityIndicator.layer.cornerRadius = 15
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        cityChangeButton.layer.cornerRadius = 15
        cityChangeButton.isHidden = true
        
        createObservers()
        
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
    
    //MARK: - Location data delegate method
    func getLocationData(lat: String, long: String) {
        WeatherService.shared.getWeatherData(lat: lat, long: long) { (temp, city, iconName) in
            guard let temp = temp, let city = city, let weatherIconName = iconName else { print("Error getting weather data"); self.cityChangeButton.setTitle("Error", for: .normal); return }
            DispatchQueue.main.async {
                self.updateUIWithWeatherData(temperature: temp, cityName: city, weatherIconName: weatherIconName)
            }
        }
    }
    
    func updateUIWithWeatherData(temperature: Int, cityName: String, weatherIconName: String) {
        if temperature > 0 {
            temperatureLabel.text = "+\(temperature)°"
        } else if temperature == 0 {
            temperatureLabel.text = "\(temperature)°"
        } else {
            temperatureLabel.text = "-\(temperature)°"
        }

        weatherIconImg.image = UIImage(named: weatherIconName)
        cityChangeButton.setTitle(cityName, for: .normal)
        cityChangeButton.isHidden = false
        cityChangeButton.isEnabled = true
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()

        print("Got update for UI: \(cityName), \(temperature), \(weatherIconName)")
    }
    
    //MARK: - Observers
    func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(EventsViewController.darkColorTheme(notification:)), name: COLOR_THEME_DARK, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EventsViewController.lightColorTheme(notification:)), name: COLOR_THEME_LIGHT, object: nil)
    }
    
    //MARK: - Color theme settings
    @objc func darkColorTheme(notification: NSNotification) {
        lightColorTheme = false
        tableView.reloadData()
    }
    
    @objc func lightColorTheme(notification: NSNotification) {
        lightColorTheme = true
        tableView.reloadData()
    }
    
    func applyColorTheme(cell: UITableViewCell) {
        switch lightColorTheme {
        case false:
            navigationController?.navigationBar.barTintColor = UIColor(hexString: "7F7F7F")
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            navigationController?.navigationBar.tintColor = UIColor.white
            tabBarController?.tabBar.barTintColor = UIColor(hexString: "7F7F7F")
            tabBarController?.tabBar.tintColor = UIColor.white
            tabBarController?.tabBar.unselectedItemTintColor = UIColor(hexString: "B3B3B3")
            self.view.backgroundColor = UIColor(hexString: "7F7F7F")
            tableView.backgroundColor = UIColor(hexString: "7F7F7F")
            cell.contentView.backgroundColor = UIColor(hexString: "7F7F7F")
            temperatureLabel.textColor = UIColor.white
        case true:
            navigationController?.navigationBar.barTintColor = UIColor(hexString: "E6E6E6")
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(hexString: "008080")]
            navigationController?.navigationBar.tintColor = UIColor(hexString: "008080")
            tabBarController?.tabBar.barTintColor = UIColor(hexString: "E6E6E6")
            tabBarController?.tabBar.tintColor = UIColor(hexString: "008080")
            tabBarController?.tabBar.unselectedItemTintColor = UIColor(hexString: "7F7F7F")
            self.view.backgroundColor = UIColor(hexString: "E6E6E6")
            tableView.backgroundColor = UIColor(hexString: "E6E6E6")
            cell.contentView.backgroundColor = UIColor(hexString: "E6E6E6")
            temperatureLabel.textColor = UIColor.black
            break
        }
    }
}

extension EventsViewController: ChangeCityName {
    
    //MARK: - Change city delegate methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let changeCityNameVC = segue.destination as! ChangeCityViewController
            changeCityNameVC.lightColorTheme = lightColorTheme
            changeCityNameVC.delegate = self
        }
    }
    
    func userChangedCityName(cityName: String) {
        cityChangeButton.setTitle(cityName, for: .normal)
        WeatherService.shared.cityWeatherUpdate(city: cityName) { (temp, city, iconName) in
            guard let temp = temp, let city = city, let weatherIconName = iconName else { print("Error getting weather data"); self.cityChangeButton.setTitle("Error", for: .normal); return }
            self.updateUIWithWeatherData(temperature: temp, cityName: city, weatherIconName: weatherIconName)
        }
    }
}
