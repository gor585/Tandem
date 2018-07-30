//
//  RegistrationInput.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 19.07.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

extension WelcomeViewController {
    
    func checkUserRegistrationInput() {
        if loginRegisterTextField.text == "" {
            let alert = UIAlertController(title: "Login is incorrect", message: "Please provide your correct e-mail adress", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Ok", style: .default, handler: { (actionOk) in })
            
            alert.addAction(actionOk)
            present(alert, animated: true, completion: nil)
            
        } else if loginRegisterTextField.text?.contains("@") == false {
            let alert = UIAlertController(title: "Incorrect e-mail", message: "The e-mail adress is badly formatted", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Ok", style: .default, handler: { (actionOk) in })
            
            alert.addAction(actionOk)
            present(alert, animated: true, completion: nil)
            
        } else if passwordRegisterTextField.text != verifyPasswordTextField.text {
            let alert = UIAlertController(title: "Password missmatch", message: "Please provide and verify valid password", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Ok", style: .default, handler: { (actionOk) in })
            
            alert.addAction(actionOk)
            present(alert, animated: true, completion: nil)
            
        } else if (passwordRegisterTextField.text?.count)! < 6 {
            let alert = UIAlertController(title: "Password is too short", message: "Password should be at least 6 characters", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Ok", style: .default, handler: { (actionOk) in })
            
            alert.addAction(actionOk)
            present(alert, animated: true, completion: nil)
            
        } else {
            userImageSelection()
        }
    }
}
