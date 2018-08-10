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
        NotificationCenter.default.addObserver(self, selector: #selector(ToDoViewController.updateUserImage(notification:)), name: USER_IMAGE_IS_CHANGED, object: nil)
    }
}
