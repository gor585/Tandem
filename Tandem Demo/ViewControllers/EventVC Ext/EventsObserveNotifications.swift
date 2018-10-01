//
//  EventsObserveNotifications.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 13.08.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

extension EventsViewController {
    
    func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(EventsViewController.darkColorTheme(notification:)), name: COLOR_THEME_DARK, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EventsViewController.lightColorTheme(notification:)), name: COLOR_THEME_LIGHT, object: nil)
    }
}
