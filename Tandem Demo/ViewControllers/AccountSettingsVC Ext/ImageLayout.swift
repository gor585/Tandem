//
//  ImageLayout.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 10.08.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

extension AccountSettingsViewController {
    
    func userImageLayout() {
        userImageView.layer.borderWidth = 1
        userImageView.layer.borderColor = UIColor.white.cgColor
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        chooseImageButton.layer.cornerRadius = userImageView.frame.width / 2
    }
}
