//
//  SettingsViewController.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 12.07.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    @IBOutlet weak var switchColorTheme: UISwitch!
    @IBOutlet weak var lightColorThemeLabel: UILabel!
    @IBOutlet weak var accountSettingsLabel: UILabel!
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchColorTheme.isOn = userDefaults.bool(forKey: "lightThemeIsOn")
        switchColorThemeNotifications()
    }
    
    //MARK: - TableView delegate methods
    override func viewWillAppear(_ animated: Bool) {
        switchColorThemeNotifications()
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        applyColorTheme(cell: cell)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //MARK: - Loging out
    @IBAction func logOutButtonPressed(_ sender: Any) {
        DataService.shared.signOut(vievController: self) {
            print("Signed Out")
        }
    }
    
    //MARK: - Switch color theme
    @IBAction func switchColorThemeButtonPressed(_ sender: UISwitch) {
        switchColorThemeNotifications()
        saveColorSettings(setting: switchColorTheme.isOn, key: "lightThemeIsOn")
        //Reloading data to apply color theme changes
        tableView.reloadData()
    }
    
    //MARK: - Segue to account settings VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAccountSettings" {
            let accountSettingsVC = segue.destination as! AccountSettingsViewController
            accountSettingsVC.lightColorTheme = switchColorTheme.isOn
        }
    }
    
    //MARK: - Post notifications
    func switchColorThemeNotifications() {
        if switchColorTheme.isOn == false {
            NotificationCenter.default.post(name: COLOR_THEME_DARK, object: nil)
            print("Switch is off")
        } else {
            NotificationCenter.default.post(name: COLOR_THEME_LIGHT, object: nil)
            print("Switch is on")
        }
    }
    
    //MARK: - Savie color theme settings
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
        DataService.shared.saveColorSettings(settingString: settingString) {
            print("Color settings saved")
        }
    }
    
    //MARK: - Color theme
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
