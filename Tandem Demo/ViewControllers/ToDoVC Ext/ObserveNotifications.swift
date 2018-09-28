//
//  ObserveNotifications.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 10.08.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import Foundation

extension ToDoViewController {
    
    func createObservers() {
        //User img changing
        NotificationCenter.default.addObserver(self, selector: #selector(ToDoViewController.updateUserImage(notification:)), name: USER_IMAGE_IS_CHANGED, object: nil)
        //Dark color theme
        NotificationCenter.default.addObserver(self, selector: #selector(ToDoViewController.darkColorTheme(notification:)), name: COLOR_THEME_DARK, object: nil)
        //Light color theme
        NotificationCenter.default.addObserver(self, selector: #selector(ToDoViewController.lightColorTheme(notification:)), name: COLOR_THEME_LIGHT, object: nil)
    }
    
    @objc func updateUserImage(notification: NSNotification) {
        DataService.shared.updateUserImage { (user, image) in
            if let user = user, let image = image {
                for item in self.itemArray {
                    if item.userLogin == user {
                        item.userImage = image
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    @objc func darkColorTheme(notification: NSNotification) {
        lightColorTheme = false
        tableView.reloadData()
    }
    
    @objc func lightColorTheme(notification: NSNotification) {
        lightColorTheme = true
        tableView.reloadData()
    }
}
