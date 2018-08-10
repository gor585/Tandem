//
//  ChangePassword.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 07.08.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

extension AccountSettingsViewController {
    
    func changePasswordModeBegin() {
        changeImageButton.isHidden = true
        changeImageButton.isEnabled = false
        changePasswordButton.isHidden = true
        changePasswordButton.isEnabled = false
        
        changePasswordStack.isHidden = false
        passwordLabel.isHidden = false
        passwordTextField.isHidden = false
        newPasswordLabel.isHidden = false
        newPasswordTextField.isHidden = false
        verifyPasswordLabel.isHidden = false
        verifyPasswordTextField.isHidden = false
        submitButton.isHidden = false
        submitButton.isEnabled = true
        cancelPasswordButton.isHidden = false
        cancelPasswordButton.isEnabled = true
    }
    
    func changePasswordModeEnded() {
        changeImageButton.isHidden = false
        changeImageButton.isEnabled = true
        changePasswordButton.isHidden = false
        changePasswordButton.isEnabled = true
        
        changePasswordStack.isHidden = true
        passwordLabel.isHidden = true
        passwordTextField.isHidden = true
        newPasswordLabel.isHidden = true
        newPasswordTextField.isHidden = true
        verifyPasswordLabel.isHidden = true
        verifyPasswordTextField.isHidden = true
        submitButton.isHidden = true
        submitButton.isEnabled = false
        cancelPasswordButton.isHidden = true
        cancelPasswordButton.isEnabled = false
    }
}
