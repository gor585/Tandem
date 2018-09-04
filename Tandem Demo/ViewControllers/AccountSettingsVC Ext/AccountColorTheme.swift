//
//  AccountColorTheme.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 13.08.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

extension AccountSettingsViewController {
    
    func applyColorTheme() {
        switch lightColorTheme {
        case false:
            self.view.backgroundColor = UIColor(hexString: "7F7F7F")
            userNameLabel.textColor = UIColor.white
            passwordLabel.textColor = UIColor.white
            newPasswordLabel.textColor = UIColor.white
            verifyPasswordLabel.textColor = UIColor.white
        default:
            self.view.backgroundColor = UIColor(hexString: "E6E6E6")
            userNameLabel.textColor = UIColor(hexString: "E6E6E6")
            passwordLabel.textColor = UIColor.black
            newPasswordLabel.textColor = UIColor.black
            verifyPasswordLabel.textColor = UIColor.black
        }
    }
}
