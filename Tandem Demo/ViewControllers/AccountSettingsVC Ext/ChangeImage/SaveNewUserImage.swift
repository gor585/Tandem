//
//  SaveNewUserImage.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 09.08.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

extension AccountSettingsViewController {
    
    func saveNewUserImage() {
        var data = NSData()
        data = UIImageJPEGRepresentation(userImageView.image!, 0.1)! as NSData
        let metadata = StorageMetadata()
        imageStorage.putData(data as Data, metadata: metadata) { (metadata, error) in
            guard let metadata = metadata else {
                print("Error ocurred: \(error!)")
                return
            }
            print("Updated profile image with metadata: \(metadata)")
            
            self.sendChangedUserImageNotification()
        }
    }
}
