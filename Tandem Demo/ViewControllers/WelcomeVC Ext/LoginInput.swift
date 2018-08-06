//
//  LoginInput.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 19.07.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import SVProgressHUD

extension WelcomeViewController {
    
    func checkUserLoginInput() {
        if usersDataDictionary.keys.contains(logInTextField.text!) == false {
            let alert = UIAlertController(title: "Login is incorrect", message: "Please provide your correct e-mail adress", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Ok", style: .default, handler: { (actionOk) in })
            
            SVProgressHUD.dismiss()
            alert.addAction(actionOk)
            present(alert, animated: true, completion: nil)
            
        } else if usersDataDictionary[logInTextField.text!] != passwordTextField.text {
            let alert = UIAlertController(title: "Password is incorrect", message: "Please provide valid password", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Ok", style: .default, handler: { (actionOk) in })
            passwordTextField.text = ""
            
            SVProgressHUD.dismiss()
            alert.addAction(actionOk)
            present(alert, animated: true, completion: nil)
            
        } else {
            Auth.auth().signIn(withEmail: logInTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                if error != nil {
                    print("Error signing in: \(error!)")
                } else {
                    SVProgressHUD.dismiss()
                    self.performSegue(withIdentifier: "toApp", sender: self)
                    print("Log in is successfull")
                    self.logInModeEnded()
                }
            })
        }
    }
}
