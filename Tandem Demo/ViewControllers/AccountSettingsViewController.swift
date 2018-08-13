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
    let imageStorage = Storage.storage().reference().child("images/user_profiles/\(Auth.auth().currentUser!.email!).jpg")
    let usersDatabaseRef = Database.database().reference().child("Users")
    let currentUser = Auth.auth().currentUser!.email!
    var lightColorTheme: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userImageLayout()
        
        imageCache.object(forKey: currentUser as NSString) != nil ? userImageView.image = imageCache.object(forKey: currentUser as NSString) : loadUserImageFromStorage()
        
        userNameLabel.text = currentUser
    }
    
    override func viewWillAppear(_ animated: Bool) {
        applyColorTheme()
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
        changePassword()
    }
    
    @IBAction func cancelPasswordModeButtonPressed(_ sender: Any) {
        changePasswordModeEnded()
    }
    
}