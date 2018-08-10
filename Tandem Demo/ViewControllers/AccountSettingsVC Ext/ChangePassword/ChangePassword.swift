//
//  ChangePassword.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 10.08.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit
import Firebase

extension AccountSettingsViewController {
    
    func changePassword() {
        usersDatabaseRef.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            let userName = snapshotValue["User"]!
            let userID = snapshotValue["ID"]!
            let userPassword = snapshotValue["Password"]!
            var oldPassword = ""
            if userName == self.currentUser {
                oldPassword = userPassword
                if self.passwordTextField.text == oldPassword && self.newPasswordTextField.text!.count >= 6 && (self.newPasswordTextField.text == self.verifyPasswordTextField.text) {
                    Auth.auth().currentUser?.updatePassword(to: self.newPasswordTextField.text!, completion: nil)
                    //Updating user password in Database
                    self.usersDatabaseRef.child(userID).child("Password").setValue(self.newPasswordTextField.text!)
                    print("User \(self.currentUser) password is changed to \(self.newPasswordTextField.text!)")
                    self.changePasswordModeEnded()
                } else if self.newPasswordTextField.text!.count < 6 {
                    let alert = UIAlertController(title: "Password is to short", message: "Password should be at least 6 characters long", preferredStyle: .alert)
                    let actionOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alert.addAction(actionOk)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Password missmatch", message: "Please provide correct password", preferredStyle: .alert)
                    let actionOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alert.addAction(actionOk)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
