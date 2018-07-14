//
//  RegisterMode.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 11.07.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import Foundation

extension WelcomeViewController {
    
    func registerModeBegin() {
        registrationStackView.isHidden = false
        loginRegisterLabel.isHidden = false
        loginRegisterTextField.isHidden = false
        passwordRegisterLabel.isHidden = false
        passwordRegisterTextField.isHidden = false
        verifyPasswordLabel.isHidden = false
        verifyPasswordTextField.isHidden = false
        
        logInButton.isHidden = true
        logInButton.isEnabled = false
        registerButton.isHidden = true
        registerButton.isEnabled = false
        
        nextRegisterButton.isHidden = false
        nextRegisterButton.isEnabled = true
        backRegisterButton.isHidden = false
        backRegisterButton.isEnabled = true
    }
    
    func registerModeEnded() {
        registrationStackView.isHidden = true
        loginRegisterLabel.isHidden = true
        loginRegisterTextField.isHidden = true
        loginRegisterTextField.text = ""
        passwordRegisterLabel.isHidden = true
        passwordRegisterTextField.isHidden = true
        passwordRegisterTextField.text = ""
        verifyPasswordLabel.isHidden = true
        verifyPasswordTextField.isHidden = true
        verifyPasswordTextField.text = ""
        
        logInButton.isHidden = false
        logInButton.isEnabled = true
        registerButton.isHidden = false
        registerButton.isEnabled = true
        
        nextRegisterButton.isHidden = true
        nextRegisterButton.isEnabled = false
        backRegisterButton.isHidden = true
        backRegisterButton.isEnabled = false
    }
}
