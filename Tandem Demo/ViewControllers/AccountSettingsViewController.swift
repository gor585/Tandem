//
//  AccountSettingsViewController.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 07.08.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit
import Firebase

class AccountSettingsViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var changeImageButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    @IBOutlet weak var changeImageStack: UIStackView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelImageButton: UIButton!
    
    @IBOutlet weak var changePasswordStack: UIStackView!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var newPasswordLabel: UILabel!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var verifyPasswordLabel: UILabel!
    @IBOutlet weak var verifyPasswordTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var cancelPasswordButton: UIButton!
    
    let imageCache = ImageCache.sharedCache
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userImageLayout()
        
        imageCache.object(forKey: Auth.auth().currentUser!.email! as NSString) != nil ? userImageView.image = imageCache.object(forKey: Auth.auth().currentUser!.email! as NSString) : print("No image avaliable")
        
        userNameLabel.text = Auth.auth().currentUser!.email
    }
    
    func userImageLayout() {
        userImageView.layer.borderWidth = 1
        userImageView.layer.borderColor = UIColor.white.cgColor
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        chooseImageButton.layer.cornerRadius = userImageView.frame.width / 2
    }
    
    //MARK: - Main options
    
    @IBAction func changeImageButtonPressed(_ sender: Any) {
        changeImageModeBegin()
    }
    
    @IBAction func changePasswordButtonPressed(_ sender: Any) {
        changePasswordModeBegin()
    }
    
    //MARK: - Change image
    
    @IBAction func chooseImageButtonPressed(_ sender: Any) {
        chooseImage()
    }
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        saveNewUserImage()
        changeImageModeEnded()
    }
    
    @IBAction func cancelImageModeButtonPressed(_ sender: Any) {
        changeImageModeEnded()
    }
    
    //MARK: - Change password
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func cancelPasswordModeButtonPressed(_ sender: Any) {
        changePasswordModeEnded()
    }
    
}
