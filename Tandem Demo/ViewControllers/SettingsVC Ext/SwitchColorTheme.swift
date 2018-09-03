//
//  SwitchColorTheme.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 11.08.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit
import Firebase

extension SettingsViewController {
    
    func switchColorThemeNotifications() {
        if switchColorTheme.isOn == false {
            NotificationCenter.default.post(name: COLOR_THEME_DARK, object: nil)
            print("Switch is off")
        } else {
            NotificationCenter.default.post(name: COLOR_THEME_LIGHT, object: nil)
            print("Switch is on")
        }
    }
    
    func saveColorSettings(setting: Bool, key: String) {
        //Saving color theme settings in UserDefaults
        userDefaults.set(setting, forKey: key)
        
        //Converting bool setting to string value
        var settingString = ""
        if switchColorTheme.isOn == true {
            settingString = "true"
        } else {
            settingString = "false"
        }
        
        //Saving color theme setting in usersDatabase
        let currentUserName = Auth.auth().currentUser!.email!
        self.usersDatabase.observe(.childAdded) { (snapshot) in
            var snapshotValue = snapshot.value as! Dictionary<String, String>
            let userLogin = snapshotValue["User"]!
            let userID = snapshotValue["ID"]!
            
            if userLogin == currentUserName {
                self.usersDatabase.child(userID).updateChildValues(["LightColorTheme": settingString])
            }
        }
    }
    
    func applyColorTheme(cell: UITableViewCell) {
        switch switchColorTheme.isOn {
        case false:
            navigationController?.navigationBar.barTintColor = UIColor(hexString: "7F7F7F")
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            navigationController?.navigationBar.tintColor = UIColor.white
            tabBarController?.tabBar.barTintColor = UIColor(hexString: "7F7F7F")
            tabBarController?.tabBar.tintColor = UIColor.white
            tabBarController?.tabBar.unselectedItemTintColor = UIColor(hexString: "B3B3B3")
            self.view.backgroundColor = UIColor(hexString: "7F7F7F")
            cell.backgroundColor = UIColor(hexString: "7F7F7F")
            logOutButton.tintColor = UIColor.white
            lightColorThemeLabel.textColor = UIColor.white
            accountSettingsLabel.textColor = UIColor.white
        case true:
            navigationController?.navigationBar.barTintColor = UIColor(hexString: "E6E6E6")
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(hexString: "008080")]
            navigationController?.navigationBar.tintColor = UIColor(hexString: "008080")
            tabBarController?.tabBar.barTintColor = UIColor(hexString: "E6E6E6")
            tabBarController?.tabBar.tintColor = UIColor(hexString: "008080")
            tabBarController?.tabBar.unselectedItemTintColor = UIColor(hexString: "7F7F7F")
            self.view.backgroundColor = UIColor(hexString: "E6E6E6")
            cell.backgroundColor = UIColor(hexString: "E6E6E6")
            logOutButton.tintColor = UIColor(hexString: "008080")
            lightColorThemeLabel.textColor = UIColor(hexString: "008080")
            accountSettingsLabel.textColor = UIColor(hexString: "008080")
        break
        }
    }
}
