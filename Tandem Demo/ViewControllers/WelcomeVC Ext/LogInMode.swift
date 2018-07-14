//
//  LogInMode.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 11.07.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import Foundation

extension WelcomeViewController {
    
    func logInModeBegin() {
        loginStackView.isHidden = false
        logInTextField.isHidden = false
        loginLabel.isHidden = false
        passwordTextField.isHidden = false
        passwordLabel.isHidden = false
        
        logInButton.isHidden = true
        logInButton.isEnabled = false
        registerButton.isHidden = true
        registerButton.isEnabled = false
        
        confirmButton.isHidden = false
        confirmButton.isEnabled = true
        backLoginButton.isHidden = false
        backLoginButton.isEnabled = true
    }
    
    func logInModeEnded() {
        loginStackView.isHidden = true
        logInTextField.isHidden = true
        logInTextField.text = ""
        loginLabel.isHidden = true
        passwordTextField.isHidden = true
        passwordTextField.text = ""
        passwordLabel.isHidden = true
        
        logInButton.isHidden = false
        logInButton.isEnabled = true
        registerButton.isHidden = false
        registerButton.isEnabled = true
        
        confirmButton.isHidden = true
        confirmButton.isEnabled = false
        backLoginButton.isHidden = true
        backLoginButton.isEnabled = false
    }
    
}
