//
//  AddItem.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 08.07.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

protocol AddItem {
    func userAddedNewItem(title: String, text: String, imageURL: String, latitude: String, longitude: String, userLogin: String, userImage: UIImage, userImgURL: String)
}
