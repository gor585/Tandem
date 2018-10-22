//
//  Event.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 08.07.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

class Event {
    var title: String
    var category: String
    var description: String
    var start: String
    var end: String
    
    init(title: String, category: String, description: String, start: String, end: String) {
        self.title = title
        self.category = category
        self.description = description
        self.start = start
        self.end = end
    }
}
