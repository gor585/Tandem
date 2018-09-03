//
//  SettingsViewController.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 12.07.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    @IBOutlet weak var switchColorTheme: UISwitch!
    @IBOutlet weak var lightColorThemeLabel: UILabel!
    @IBOutlet weak var accountSettingsLabel: UILabel!
    
    let userDefaults = UserDefaults.standard
    let usersDatabase = Database.database().reference().child("Users")
    let currentUserName = Auth.auth().currentUser!.email!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchColorTheme.isOn = userDefaults.bool(forKey: "lightThemeIsOn")
        switchColorThemeNotifications()
    }
    
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
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        signOut()
    }
    
    @IBAction func switchColorThemeButtonPressed(_ sender: UISwitch) {
        switchColorThemeNotifications()
        saveColorSettings(setting: switchColorTheme.isOn, key: "lightThemeIsOn")
        //Reloading data to apply color theme changes
        tableView.reloadData()
    }
}
