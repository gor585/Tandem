//
//  ChangePassword.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 07.08.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

extension AccountSettingsViewController {
    
    //MARK: - Change img modes
    func changeImageModeBegin() {
        changeImageButton.isHidden = true
        changeImageButton.isEnabled = false
        changePasswordButton.isHidden = true
        changePasswordButton.isEnabled = false
        
        changeImageStack.isHidden = false
        chooseImageButton.isHidden = false
        chooseImageButton.isEnabled = true
        confirmButton.isHidden = false
        confirmButton.isEnabled = true
        cancelImageButton.isHidden = false
        cancelImageButton.isEnabled = true
    }
    
    func changeImageModeEnded() {
        changeImageButton.isHidden = false
        changeImageButton.isEnabled = true
        changePasswordButton.isHidden = false
        changePasswordButton.isEnabled = true
        
        changeImageStack.isHidden = true
        chooseImageButton.isHidden = true
        chooseImageButton.isEnabled = false
        confirmButton.isHidden = true
        confirmButton.isEnabled = false
        cancelImageButton.isHidden = true
        cancelImageButton.isEnabled = false
    }
    
    //MARK: - Change pass modes
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
        passwordTextField.text = ""
        newPasswordLabel.isHidden = true
        newPasswordTextField.isHidden = true
        newPasswordTextField.text = ""
        verifyPasswordLabel.isHidden = true
        verifyPasswordTextField.isHidden = true
        verifyPasswordTextField.text = ""
        submitButton.isHidden = true
        submitButton.isEnabled = false
        cancelPasswordButton.isHidden = true
        cancelPasswordButton.isEnabled = false
    }
}
