//
//  RetrieveItem.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 13.07.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit
import Firebase

extension ToDoViewController {
    
    func retrieveItems() {
        itemsDatabase.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            
            let user = snapshotValue["User"]!
            let title = snapshotValue["Title"]!
            let text = snapshotValue["Text"]!
            let date = snapshotValue["Date"]!
            
            let item = Item(title: title, image: UIImage(named: "tandem"), text: text, userLogin: user, userImage: UIImage(named: "tandem"))
            item.date = date
            
            self.itemArray.append(item)
            self.tableView.reloadData()
        }
    }
}
