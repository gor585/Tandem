//
//  ChangeImage.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 07.08.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

extension AccountSettingsViewController {
    
    func changeImageModeBegin() {
        changeImageButton.isHidden = true
        changeImageButton.isEnabled = false
        changePasswordButton.isHidden = true
        changePasswordButton.isEnabled = false
        
        changeImageStack.isHidden = false
        chooseImageButton.isHidden = false
        chooseImageButton.isEnabled = true
        confirmButton.isHidden = false
        confirmButton.isEnabled = true
        cancelImageButton.isHidden = false
        cancelImageButton.isEnabled = true
    }
    
    func changeImageModeEnded() {
        changeImageButton.isHidden = false
        changeImageButton.isEnabled = true
        changePasswordButton.isHidden = false
        changePasswordButton.isEnabled = true
        
        changeImageStack.isHidden = true
        chooseImageButton.isHidden = true
        chooseImageButton.isEnabled = false
        confirmButton.isHidden = true
        confirmButton.isEnabled = false
        cancelImageButton.isHidden = true
        cancelImageButton.isEnabled = false
    }
}
