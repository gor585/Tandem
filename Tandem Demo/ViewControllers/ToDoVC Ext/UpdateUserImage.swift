//
//  UpdateUserImage.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 10.08.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit
import Firebase

extension ToDoViewController {
    
    @objc func updateUserImage(notification: NSNotification) {
        var userImage = UIImage(named: "tandem")
        let userEmail = Auth.auth().currentUser!.email!
        let userImageDatabase = Database.database().reference().child("UserImg")
        userImageDatabase.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            //getting all users (as keys for img url values)
            let users = snapshotValue.keys
            //separate email to prevent "." in key name
            let delimeter = "."
            let separatedEmail = userEmail.components(separatedBy: delimeter)
            let userName = separatedEmail[0]
            
            for user in users {
                if user == userName {
                    //getting img url string of current user
                    let userImgURLString = snapshotValue[user]!
                    let userImageURL = URL(string: userImgURLString)
                    
                    //checking if image cache contains current user image & updating this image with data from userImageURL
                    if self.imageCache.object(forKey: userEmail as NSString) != nil {
                        do {
                            let imageData = try Data.init(contentsOf: userImageURL!)
                            self.imageCache.setObject(UIImage(data: imageData)!, forKey: userEmail as NSString)
                            print("\(user) image updated and added to cache")
                            
                            userImage = self.imageCache.object(forKey: userEmail as NSString)
                            
                            //Updating user image in existing items
                            for item in self.itemArray {
                                if item.userLogin == userEmail {
                                    item.userImage = userImage
                                    self.tableView.reloadData()
                                }
                            }

                        } catch {
                            print("Error retrieving data from \(userImageURL!)")
                        }
                    } else {
                         print("No matches found in cache")
                    }
                }
            }
        }
    }
}
