//
//  EditItem.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 17.07.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

protocol EditItem {
    func userEditedItem(atIndex: Int, title: String, image: UIImage, text: String)
    func userDeletedItem(atIndex: Int)
}
