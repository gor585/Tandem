//
//  AddNewItem.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 13.07.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit
import Firebase

extension ToDoViewController: AddItem {
    
    func userAddedNewItem(title: String, image: UIImage, text: String, userLogin: String, userImage: UIImage, userImgURL: String) {
        
        let newItem = Item(title: title, image: image, text: text, userLogin: userLogin, userImage: userImage, userImgURL: userImgURL)
//        itemArray.append(newItem)  ---> app is already retrieving data from Firebase via retrieveItems() and appending it to itemArray
        
        let itemsDictionary = ["User": Auth.auth().currentUser?.email, "UserImageURL": newItem.userImgURL, "Title": newItem.title, "Text": newItem.text, "Date": newItem.date]
        DispatchQueue.global(qos: .userInteractive).async {
            self.itemsDatabase.childByAutoId().setValue(itemsDictionary) {
                (error, reference) in
                if error != nil {
                    print("Error: \(error!)")
                } else {
                    print("Item saved successfully")
                }
            }
        }
        tableView.reloadData()
    }
}
