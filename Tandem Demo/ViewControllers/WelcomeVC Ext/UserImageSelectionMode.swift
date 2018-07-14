//
//  UserImageSelectionMode.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 11.07.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

extension WelcomeViewController {
    
    func userImageSelection() {
        registrationStackView.isHidden = true
        loginRegisterLabel.isHidden = true
        loginRegisterTextField.isHidden = true
        passwordRegisterLabel.isHidden = true
        passwordRegisterTextField.isHidden = true
        verifyPasswordLabel.isHidden = true
        verifyPasswordTextField.isHidden = true
        
        userImageView.isHidden = false
        chooseImageButton.isHidden = false
        chooseImageButton.isEnabled = true
        chooseImageButton.layer.borderWidth = 1
        chooseImageButton.layer.borderColor = UIColor.white.cgColor
        
        nextRegisterButton.isHidden = true
        nextRegisterButton.isEnabled = false
        backRegisterButton.isHidden = true
        backRegisterButton.isEnabled = false
        
        backUserImageButton.isHidden = false
        backUserImageButton.isEnabled = true
        
        submitButton.isHidden = false
        submitButton.isEnabled = true
    }
    
    func userImageSelectionEnded() {
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
        
        userImageView.image = nil
        userImageView.isHidden = true
        chooseImageButton.isHidden = true
        chooseImageButton.isEnabled = false
        
        nextRegisterButton.isHidden = false
        nextRegisterButton.isEnabled = true
        backRegisterButton.isHidden = false
        backRegisterButton.isEnabled = true
        
        backUserImageButton.isHidden = true
        backUserImageButton.isEnabled = false
        
        submitButton.isHidden = true
        submitButton.isEnabled = false
    }
}
