//
//  ImageSelection.swift
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
    
    func createUserAndUploadImage() {
        if userImageView.image == nil {
            let alert = UIAlertController(title: "No photo provided", message: "Please choose an image for your profile", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Ok", style: .default, handler: { (actionOk) in })
            
            alert.addAction(actionOk)
            present(alert, animated: true, completion: nil)
            
        } else {
            Auth.auth().createUser(withEmail: self.loginRegisterTextField.text!, password: self.passwordRegisterTextField.text!) { (user, error) in
                if error != nil {
                    print("Error occured: \(error!)")
                } else {
                    print("Registration of \(user!) is successfull")
                }
            }
            
            userEmail = loginRegisterTextField.text!
            let delimeter = "."
            let separatedEmail = userEmail.components(separatedBy: delimeter)
            let userName = separatedEmail[0]
            
            var data = NSData()
            data = UIImageJPEGRepresentation(userImageView.image!, 0.01)! as NSData
            
            let metadata = StorageMetadata()
            let imageStorage = Storage.storage().reference().child("images/user_profiles")
            imageStorage.child("\(loginRegisterTextField.text!).jpg").putData(data as Data, metadata: metadata) { (metadata, error) in
                guard let metadata = metadata else {
                    print("Error ocurred: \(error!)")
                    return
                }
                print("Uploaded profile image with metadata: \(metadata)")
                print(metadata.downloadURL()!.absoluteString)
                
                let userImgDatabase = Database.database().reference().child("UserImg")
                let userImgDictionary = ["\(userName)": "\(metadata.downloadURL()!.absoluteString)"]
                print(userName)
                
                userImgDatabase.childByAutoId().setValue(userImgDictionary) {
                    (error, reference) in
                    if error != nil {
                        print("Error: \(error!)")
                    } else {
                        print("User image url saved successfully")
                    }
                }
            }
            
            SVProgressHUD.dismiss()
            
            performSegue(withIdentifier: "toApp", sender: self)
            userImageSelectionEnded()
            registerModeEnded()
        }
    }
}
