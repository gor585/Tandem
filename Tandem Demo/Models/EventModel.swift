//
//  Event.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 08.07.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

class Event {
    let title: String?
    var image: UIImage?
    let url: String?
    
    init(title: String, image: UIImage, url: String) {
        self.title = title
        self.image = image
        self.url = url
    }
}
