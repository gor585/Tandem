//
//  EventsViewController.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 07.07.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var eventArray = [Event]()
    
    let planetaKino = Event(title: "Planeta Kino", image: UIImage(named: "planetaKino")!, url: "https://planetakino.ua/lvov2/showtimes/#imax_4dx_relux_cinetech_vr_2d_3d_one-day")
    let kinopalace = Event(title: "Kinopalace",image: UIImage(named: "kinopalace")!, url: "http://kinopalace.lviv.ua/schedule/")
    let lesya = Event(title: "Teatr Lesi",image: UIImage(named: "teatr-lesi")!, url: "http://teatrlesi.lviv.ua/events/")
    let kurbas = Event(title: "Teatr Kurbasa",image: UIImage(named: "kurbas-1")!, url: "http://www.kurbas.lviv.ua/afisha/")
    let philarmony = Event(title: "Philarmony",image: UIImage(named: "philarmony")!, url: "https://philharmonia.lviv.ua/events/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        eventArray.append(planetaKino)
        eventArray.append(kinopalace)
        eventArray.append(lesya)
        eventArray.append(kurbas)
        eventArray.append(philarmony)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! EventCell
        cell.eventImage?.image = eventArray[indexPath.row].image
        cell.eventTitleLabel.text = eventArray[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: eventArray[indexPath.row].url!) else { return }
        UIApplication.shared.open(url as URL)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

}
