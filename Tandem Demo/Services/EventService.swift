//
//  EventService.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 22.10.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import Foundation

class EventService {
    static let shared = EventService()
    
    func getEvents(city: String, completion: @escaping (_ eventsArray: [Event]?) -> Void) {
        var eventsArray = [Event]()
        let predictAPIToken = "ZIGiJ49BK3z9fDSsy2ATlSGmyKKo09"
        let baseURLString = "https://api.predicthq.com/v1/events/?q=\(city)&active.gte=\(DateConverter.shared.lastTwoWeeksDateString)&active.lte=\(DateConverter.shared.nextTwoWeeksDateString)"
        
        guard let url = URL(string: baseURLString) else { print("No url available"); return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(predictAPIToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil {
                guard let response = response as? HTTPURLResponse else { return }
                if response.statusCode == 200 {
                    guard let data = data else { return }
                    guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else { print("JSON serialization error"); return }
                    guard let dict = json as? [String: Any] else { return }
                    guard let results = dict["results"] as? [[String: Any]] else { return }
                    //Checking if there are available events
                    if results.count > 0 {
                        for result in results {
                            guard let title = result["title"] as? String else { return }
                            guard let category = result["category"] as? String else { return }
                            guard let description = result["description"] as? String else { return }
                            guard let start = result["start"] as? String else { return }
                            guard let end = result["end"] as? String else { return }
                            guard let location = result["location"] as? [Any] else { return }
                            let latitude = String(describing: location[1])
                            let longitude = String(describing: location[0])
                            
                            let newEvent = Event(title: title, category: category, description: description, start: start, end: end, lat: latitude, long: longitude) 
                            eventsArray.append(newEvent)
                            completion(eventsArray)
                        }
                    } else {
                        //If no events are available in this location -> return empty array
                        completion(eventsArray)
                    }
                } else {
                    print("Response status: \(response.statusCode)")
                }
            } else {
                print("Error getting events: \(error!.localizedDescription)")
            }
        }.resume()
    }
}
