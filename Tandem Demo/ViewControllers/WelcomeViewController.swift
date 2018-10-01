//
//  ViewController.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 07.07.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit
import SVProgressHUD

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var logInTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginRegisterLabel: UILabel!
    @IBOutlet weak var loginRegisterTextField: UITextField!
    @IBOutlet weak var passwordRegisterLabel: UILabel!
    @IBOutlet weak var passwordRegisterTextField: UITextField!
    @IBOutlet weak var verifyPasswordLabel: UILabel!
    @IBOutlet weak var verifyPasswordTextField: UITextField!
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var chooseImageButton: UIButton!
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var nextRegisterButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var backLoginButton: UIButton!
    @IBOutlet weak var backRegisterButton: UIButton!
    @IBOutlet weak var backUserImageButton: UIButton!
    
    @IBOutlet weak var loginStackView: UIStackView!
    @IBOutlet weak var registrationStackView: UIStackView!
    
    var userEmail = ""
    var usersDataDictionary = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logInTextField.delegate = self
        passwordTextField.delegate = self
        loginRegisterTextField.delegate = self
        passwordRegisterTextField.delegate = self
        verifyPasswordTextField.delegate = self
        
        self.hideKeyboardWhenTappedAround()
    }

    @IBAction func logInButtonPressed(_ sender: Any) {
        logInModeBegin()
        DataService.shared.retrieveUsersData { (data) in
            self.usersDataDictionary = data
        }
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        registerModeBegin()
    }
    
    @IBAction func backLoginButtonPressed(_ sender: Any) {
        logInModeEnded()
    }
    
    @IBAction func backRegisterButtonPressed(_ sender: Any) {
        registerModeEnded()
    }
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        SVProgressHUD.show()
        checkUserLoginInput()
    }
    
    @IBAction func nextRegisterButtonPressed(_ sender: Any) {
        checkUserRegistrationInput()
    }
    
    @IBAction func backUserImageButtonPressed(_ sender: Any) {
        userImageSelectionEnded()
    }
    
    @IBAction func chooseImageButtonPressed(_ sender: Any) {
        chooseImage()
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        SVProgressHUD.show()
        DataService.shared.createUser(withEmail: loginRegisterTextField.text!, password: passwordRegisterTextField.text!, image: userImageView.image!) { user, password, image in
            SVProgressHUD.dismiss()
            self.userImageSelectionEnded()
            self.registerModeEnded()
        }
        
    }
    
    func textFieldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

//MARK: - Image Picker
extension WelcomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Image Source", message: "Choose your image source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
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
        chooseImageButton.backgroundColor = UIColor.clear
        chooseImageButton.imageView?.image = pickedImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

