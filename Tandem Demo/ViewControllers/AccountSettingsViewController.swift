//
//  AccountSettingsViewController.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 07.08.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

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
    
    var lightColorTheme: Bool = true
    var userImg: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userImageLayout()
        
        //Get user image from cache or from the Storage
        DataService.shared.getUserImageFromCache { (userName, userImage) in
            guard let user = userName else { return }
            guard let image = userImage else { return }
            self.userNameLabel.text = user
            self.userImageView.image = image
        }
        
        //Saving original user image
        userImg = userImageView.image
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
    
    //MARK: - Save new image to Storage
    @IBAction func confirmButtonPressed(_ sender: Any) {
        guard let image = userImageView.image else { return }
        DataService.shared.replaceUserImageWithNewOne(newImage: image) {
            self.sendChangedUserImageNotification()
        }
        changeImageModeEnded()
    }
    
    @IBAction func cancelImageModeButtonPressed(_ sender: Any) {
        //Back to original user image
        userImageView.image = userImg
        changeImageModeEnded()
    }
    
    //MARK: - Change password
    @IBAction func submitButtonPressed(_ sender: Any) {
        guard let password = passwordTextField.text else { return }
        guard let newPassword = newPasswordTextField.text else { return }
        guard let verifyPassword = verifyPasswordTextField.text else { return }
        DataService.shared.changePassword(password: password, newPassword: newPassword, verifyPassword: verifyPassword, viewController: self) { newPasswordString in
            if newPasswordString != nil {
                self.changePasswordModeEnded()
            }
        }
    }
    
    @IBAction func cancelPasswordModeButtonPressed(_ sender: Any) {
        changePasswordModeEnded()
    }
    
    //MARK: - Post notification on changing user image
    func sendChangedUserImageNotification() {
        NotificationCenter.default.post(name: USER_IMAGE_IS_CHANGED, object: nil)
    }
    
    //MARK: - User image layout
    func userImageLayout() {
        userImageView.layer.borderWidth = 1
        userImageView.layer.borderColor = UIColor.white.cgColor
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        chooseImageButton.layer.cornerRadius = userImageView.frame.width / 2
    }
    
    //MARK: - Color theme
    func applyColorTheme() {
        switch lightColorTheme {
        case false:
            self.view.backgroundColor = UIColor(hexString: "7F7F7F")
            userNameLabel.textColor = UIColor.white
            passwordLabel.textColor = UIColor.white
            newPasswordLabel.textColor = UIColor.white
            verifyPasswordLabel.textColor = UIColor.white
        default:
            self.view.backgroundColor = UIColor(hexString: "E6E6E6")
            userNameLabel.textColor = UIColor(hexString: "008080")
            passwordLabel.textColor = UIColor.black
            newPasswordLabel.textColor = UIColor.black
            verifyPasswordLabel.textColor = UIColor.black
        }
    }
}

//MARK: - ImagePicker
extension AccountSettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Image source", message: "Choose your image source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo library", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        userImageView.image = pickedImage
        chooseImageButton.imageView?.image = pickedImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
