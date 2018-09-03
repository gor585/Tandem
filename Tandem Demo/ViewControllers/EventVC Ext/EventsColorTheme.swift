//
//  EventsColorTheme.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 13.08.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit
import Firebase

extension EventsViewController {
    
    @objc func darkColorTheme(notification: NSNotification) {
        lightColorTheme = false
        tableView.reloadData()
    }
    
    @objc func lightColorTheme(notification: NSNotification) {
        lightColorTheme = true
        tableView.reloadData()
    }
    
    func applyColorTheme(cell: UITableViewCell) {
        switch lightColorTheme {
        case false:
            navigationController?.navigationBar.barTintColor = UIColor(hexString: "7F7F7F")
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            navigationController?.navigationBar.tintColor = UIColor.white
            tabBarController?.tabBar.barTintColor = UIColor(hexString: "7F7F7F")
            tabBarController?.tabBar.tintColor = UIColor.white
            tabBarController?.tabBar.unselectedItemTintColor = UIColor(hexString: "B3B3B3")
            self.view.backgroundColor = UIColor(hexString: "7F7F7F")
            tableView.backgroundColor = UIColor(hexString: "7F7F7F")
            cell.contentView.backgroundColor = UIColor(hexString: "7F7F7F")
            temperatureLabel.textColor = UIColor.white
        case true:
            navigationController?.navigationBar.barTintColor = UIColor(hexString: "E6E6E6")
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(hexString: "008080")]
            navigationController?.navigationBar.tintColor = UIColor(hexString: "008080")
            tabBarController?.tabBar.barTintColor = UIColor(hexString: "E6E6E6")
            tabBarController?.tabBar.tintColor = UIColor(hexString: "008080")
            tabBarController?.tabBar.unselectedItemTintColor = UIColor(hexString: "7F7F7F")
            self.view.backgroundColor = UIColor(hexString: "E6E6E6")
            tableView.backgroundColor = UIColor(hexString: "E6E6E6")
            cell.contentView.backgroundColor = UIColor(hexString: "E6E6E6")
            temperatureLabel.textColor = UIColor.black
        break
        }
    }
}
