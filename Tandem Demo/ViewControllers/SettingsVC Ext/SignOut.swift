//
//  SignOut.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 20.07.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

extension SettingsViewController {
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            print("Signed out sucessfully")
        } catch {
            let alert = UIAlertController(title: "Error", message: "Could not sign out", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Ok", style: .default, handler: { (actionOk) in })
            
            alert.addAction(actionOk)
            present(alert, animated: true, completion: nil)
            print("Error while signing out")
        }
    }
}
