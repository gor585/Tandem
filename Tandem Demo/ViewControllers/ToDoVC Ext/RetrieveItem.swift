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
import SVProgressHUD

extension ToDoViewController {
    
    func retrieveItems() {
        SVProgressHUD.show()
        itemsDatabase.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            
            let user = snapshotValue["User"]!
            let title = snapshotValue["Title"]!
            let text = snapshotValue["Text"]!
            let date = snapshotValue["Date"]!
            let isDone = snapshotValue["IsDone"]!
            let userImgURLString = snapshotValue["UserImageURL"]!
            let id = snapshotValue["ID"]!
            
            var userImage = UIImage(named: "tandem")
            let userImgURL = URL(string: userImgURLString)
            
            if self.imageCache.object(forKey: user as NSString) == nil {
                do {
                    let imageData = try Data.init(contentsOf: userImgURL!)
                    self.imageCache.setObject(UIImage(data: imageData)!, forKey: user as NSString)
                    print("Image of \(user) added to cache")
                } catch {
                    print("Error retrieving data from \(userImgURL!)")
                }
            } else {
                print("Cache alresdy contains \(user) image")
            }
            
            userImage = self.imageCache.object(forKey: user as NSString)
            
            let item = Item(title: title, image: userImage, text: text, userLogin: user, userImage: userImage, userImgURL: userImgURLString)
            item.date = date
            item.id = id
            
            if isDone == "true" {
                item.done = true
            } else {
                item.done = false
            }
            
            self.itemArray.append(item)
            print("Item \(item.title!) appended to array!")
            self.allRetrievedItemsArray.append(item)
            
            print("RETRIEVED DATA Async !!!!!!!!")
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
            self.currentUserItems = self.itemArray.filter {$0.userLogin == Auth.auth().currentUser?.email}
        }
    }
}
