//
//  UsersDatabase.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 02.08.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit
import Firebase

extension WelcomeViewController {
    
    func retrieveUsersData() {
        let database = Database.database().reference().child("Users")
        database.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            let user = snapshotValue["User"]!
            let password = snapshotValue["Password"]!
            self.usersDataDictionary.updateValue(password, forKey: user)
        }
    }
}
