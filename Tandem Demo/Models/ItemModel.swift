//
//  ItemModel.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 08.07.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

class Item {
    let currentDate = Date()
    var date = ""
    var title: String?
    var text: String?
    var image: UIImage?
    var done: Bool
    
    var userLogin: String
    var userImage: UIImage?
    
    init(title: String? = "", image: UIImage? = UIImage(named: "camera"), text: String? = "", userLogin: String, userImage: UIImage? = UIImage(named: "camera")) {
        self.title = title
        self.image = image
        self.text = text
        self.userLogin = userLogin
        self.userImage = userImage
        self.done = false
        
        date = dateString(dateToString: currentDate)
    }
}
