//
//  DetailsMod.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 17.07.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

extension DetailsViewController {
    
    func detailsModeBegin() {
        detailsTitleLabel.isHidden = false
        detailsImageView.isHidden = false
        detailsTextView.isHidden = false
        detailsView.isHidden = false
        editButton.isHidden = false
        editButton.isEnabled = true
        deleteButton.isHidden = false
        deleteButton.isEnabled = true
        
        editTitleTextField.isHidden = true
        editImageView.isHidden = true
        editView.isHidden = true
        EditTextView.isHidden = true
        changeImageButton.isHidden = true
        changeImageButton.isEnabled = false
        confirmButton.isHidden = true
        confirmButton.isEnabled = false
    }
    
    func detailsModeEnded() {
        detailsTitleLabel.isHidden = true
        detailsImageView.isHidden = true
        detailsTextView.isHidden = true
        detailsView.isHidden = true
        editButton.isHidden = true
        editButton.isEnabled = false
        deleteButton.isHidden = true
        deleteButton.isEnabled = false
        
        editTitleTextField.isHidden = false
        editImageView.isHidden = false
        editView.isHidden = false
        EditTextView.isHidden = false
        changeImageButton.isHidden = false
        changeImageButton.isEnabled = true
        confirmButton.isHidden = false
        confirmButton.isEnabled = true
    }
}
