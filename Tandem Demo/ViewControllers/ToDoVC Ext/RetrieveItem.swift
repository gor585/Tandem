//
//  RetrieveItem.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 13.07.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

extension ToDoViewController {
    
    func retrieveItems() {
        itemsDatabase.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            
            let user = snapshotValue["User"]!
            let title = snapshotValue["Title"]!
            let text = snapshotValue["Text"]!
            let date = snapshotValue["Date"]!
            let userImgURLString = snapshotValue["UserImageURL"]!
            
            var userImage = UIImage(named: "tandem")
            
            let userImgURL = URL(string: userImgURLString)
            do {
                let imageData = try Data.init(contentsOf: userImgURL!)
                userImage = UIImage(data: imageData)!
            } catch {
                print("Error retrieving data from \(userImgURL!)")
            }
                
            let item = Item(title: title, image: userImage, text: text, userLogin: user, userImage: userImage, userImgURL: userImgURLString)
            item.date = date
            
            self.itemArray.append(item)
            self.tableView.reloadData()
            
        }
    }
}
