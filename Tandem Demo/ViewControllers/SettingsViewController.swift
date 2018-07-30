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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        signOut()
    }
}
