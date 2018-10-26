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
    @IBOutlet weak var tableViewActivityIndicator: UIActivityIndicatorView!
    
    var eventArray = [Event]()
    let userDefaults = UserDefaults.standard
    var lightColorTheme = Bool()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableViewActivityIndicator.startAnimating()
        
        //Getting location for weather update
        LocationService.shared.delegate = self
        LocationService.shared.locationManager.startUpdatingLocation()
        
        //Registering eventCell nib in tableView
        let cellNib = UINib(nibName: "EventCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "eventCell")

        activityIndicator.layer.cornerRadius = 15
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        cityChangeButton.layer.cornerRadius = 15
        cityChangeButton.isHidden = true
        
        createObservers()
        
        lightColorTheme = userDefaults.bool(forKey: "lightThemeIsOn")
    }
    
    //MARK: - TableView delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! EventCell
        //Applying selected color theme
        applyColorTheme(cell: cell)
        cell.setEvent(event: eventArray[indexPath.row])
        
        if eventArray[indexPath.row].selected == true {
            cell.contentView.backgroundColor = UIColor(hexString: "008080")
            cell.titleLabel.textColor = UIColor.white
            cell.startLabel.textColor = UIColor.white
            cell.endLabel.textColor = UIColor.white
        } else {
            cell.backgroundColor = UIColor(hexString: "E6E6E6")
            cell.titleLabel.textColor = UIColor.black
            cell.startLabel.textColor = UIColor.black
            cell.endLabel.textColor = UIColor.black
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toEventDescription", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let event = eventArray[indexPath.row]
        let select = UITableViewRowAction(style: .default, title: "Select") { (action, indexPath) in
            DataService.shared.getUserImg(completion: { (userName, userImage, url) in
                guard let name = userName else { return }
                guard let image = userImage else { return }
                guard let url = url else { return }
                //MARK: - Add new item in ToDo list
                DataService.shared.addNewItem(title: event.title, text: event.description + "\n Location: \(event.lat), \(event.long), \n Start: \(event.start),\n End: \(event.end).", userLogin: name, userImage: image, userImgURL: url, completion: { (newItemDict) in })
            })
            event.selected = true
            tableView.reloadData()
        }
        select.backgroundColor = UIColor(hexString: "008080")
        return [select]
    }

    @IBAction func cityChangeButtonPressed(_ sender: Any) {
    }
    
    //MARK: - Location data delegate method
    func getLocationData(lat: String, long: String) {
        //MARK: - Getting weather data in current location
        WeatherService.shared.getWeatherData(lat: lat, long: long) { (temp, city, iconName) in
            guard let temp = temp, let city = city, let weatherIconName = iconName else { print("Error getting weather data"); self.cityChangeButton.setTitle("Error", for: .normal); return }
            DispatchQueue.main.async {
                self.updateUIWithWeatherData(temperature: temp, cityName: city, weatherIconName: weatherIconName)
            }
            
            //MARK: - Getting events in current location
            EventService.shared.getEvents(city: city, completion: { (events) in
                guard let eventsArray = events else { return }
                self.eventArray = eventsArray
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableViewActivityIndicator.isHidden = true
                    self.tableViewActivityIndicator.stopAnimating()
                }
            })
        }
    }
    
    func updateUIWithWeatherData(temperature: Int, cityName: String, weatherIconName: String) {
        if temperature > 0 {
            temperatureLabel.text = "+\(temperature)°"
        } else if temperature == 0 {
            temperatureLabel.text = "\(temperature)°"
        } else {
            temperatureLabel.text = "\(temperature)°"
        }

        weatherIconImg.image = UIImage(named: weatherIconName)
        cityChangeButton.setTitle(cityName, for: .normal)
        cityChangeButton.isHidden = false
        cityChangeButton.isEnabled = true
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
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
    
    func applyColorTheme(cell: EventCell) {
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
            cell.titleLabel.textColor = UIColor.white
            cell.startLabel.textColor = UIColor.white
            cell.endLabel.textColor = UIColor.white
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
            cell.titleLabel.textColor = UIColor.black
            cell.startLabel.textColor = UIColor.black
            cell.endLabel.textColor = UIColor.black
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
            guard let cityName = cityChangeButton.titleLabel?.text else { return }
            changeCityNameVC.currentCityName = cityName
            changeCityNameVC.delegate = self
        }
        
        if segue.identifier == "toEventDescription" {
            let descriptionVC = segue.destination as! DescriptionViewController
            guard let index = tableView.indexPathForSelectedRow?.row else { return }
            descriptionVC.event = eventArray[index]
            descriptionVC.lightColorTheme = lightColorTheme
        }
    }
    
    func userChangedCityName(cityName: String) {
        tableViewActivityIndicator.isHidden = false
        tableViewActivityIndicator.startAnimating()
        //Clearing event tableView
        eventArray.removeAll()
        tableView.reloadData()
        
        cityChangeButton.setTitle(cityName, for: .normal)
        WeatherService.shared.cityWeatherUpdate(city: cityName) { (temp, city, iconName) in
            guard let temp = temp, let city = city, let weatherIconName = iconName else { print("Error getting weather data"); self.cityChangeButton.setTitle("Error", for: .normal); return }
            self.updateUIWithWeatherData(temperature: temp, cityName: city, weatherIconName: weatherIconName)
        }
        EventService.shared.getEvents(city: cityName) { (events) in
            guard let eventArray = events else { return }
            self.eventArray = eventArray
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableViewActivityIndicator.isHidden = true
                self.tableViewActivityIndicator.stopAnimating()
            }
        }
    }
}
