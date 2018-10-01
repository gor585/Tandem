//
//  ColorTheme.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 11.08.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

extension ToDoViewController {
    
    func applyColorThemeToCells(cell: UITableViewCell) {
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
            filterDoneButton.tintColor = UIColor.white
            filterUsersButton.tintColor = UIColor.white
            addItemButton.tintColor = UIColor.white
            cell.contentView.backgroundColor = UIColor(hexString: "7F7F7F")
        case true:
            navigationController?.navigationBar.barTintColor = UIColor(hexString: "E6E6E6")
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(hexString: "008080")]
            navigationController?.navigationBar.tintColor = UIColor(hexString: "008080")
            tabBarController?.tabBar.barTintColor = UIColor(hexString: "E6E6E6")
            tabBarController?.tabBar.tintColor = UIColor(hexString: "008080")
            tabBarController?.tabBar.unselectedItemTintColor = UIColor(hexString: "7F7F7F")
            self.view.backgroundColor = UIColor(hexString: "E6E6E6")
            tableView.backgroundColor = UIColor(hexString: "E6E6E6")
            filterDoneButton.tintColor = UIColor(hexString: "008080")
            filterUsersButton.tintColor = UIColor(hexString: "008080")
            addItemButton.tintColor = UIColor(hexString: "008080")
            cell.contentView.backgroundColor = UIColor(hexString: "E6E6E6")
            break
        }
    }
}
