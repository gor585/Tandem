//
//  SwitchColorTheme.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 11.08.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

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
        userDefaults.set(setting, forKey: key)
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
