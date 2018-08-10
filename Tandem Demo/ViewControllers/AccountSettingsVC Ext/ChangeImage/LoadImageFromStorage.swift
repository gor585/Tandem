//
//  LoadImageFromStorage.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 10.08.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

extension AccountSettingsViewController {
    
    func loadUserImageFromStorage() {
        imageStorage.getMetadata { (metadata, error) in
            guard let metadata = metadata else {
                print("Error occured getting data from storage")
                return
            }
            let userImageURL = metadata.downloadURL()!.absoluteURL
            do {
                let imageData = try Data.init(contentsOf: userImageURL)
                self.userImageView.image = UIImage(data: imageData)
                print("Image loaded from storage")
            } catch {
                print("Unable to load image from \(userImageURL)")
            }
        }
    }
}
