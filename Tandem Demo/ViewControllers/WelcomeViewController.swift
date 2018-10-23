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

extension WelcomeViewController {
    
    //MARK: - Login input checking
    func checkUserLoginInput() {
        if usersDataDictionary.keys.contains(logInTextField.text!) == false {
            AlertView.shared.showAlert(fromController: self, withTitle: "Login is incorrect", message: "Please provide your correct e-mail adress")
            SVProgressHUD.dismiss()
            
        } else if usersDataDictionary[logInTextField.text!] != passwordTextField.text {
            print(usersDataDictionary[logInTextField.text!]!)
            AlertView.shared.showAlert(fromController: self, withTitle: "Password is incorrect", message: "Please provide valid password")
            SVProgressHUD.dismiss()
            
        } else {
            guard let login = logInTextField.text else { return }
            guard let password = passwordTextField.text else { return }
            DataService.shared.signIn(withEmail: login, password: password, completion: { (isSuccess) in
                if isSuccess == true {
                    //MARK: - Loading preferred color settings of current user and posting notifications
                    DataService.shared.loadColorThemeSetting(completion: { (colorTheme) in })
                    SVProgressHUD.dismiss()
                    self.logInModeEnded()
                } else {
                    print("Error signing in")
                }
            })
        }
    }
    
    //MARK: - Registration input check
    func checkUserRegistrationInput() {
        if loginRegisterTextField.text == "" {
            AlertView.shared.showAlert(fromController: self, withTitle: "Login field is empty", message: "Please provide your e-mail adress")
            
        } else if loginRegisterTextField.text?.contains("@") == false || loginRegisterTextField.text?.contains(".") == false ||
            loginRegisterTextField.text?.contains("com") == false {
            AlertView.shared.showAlert(fromController: self, withTitle: "Incorrect e-mail", message: "The e-mail adress is badly formatted")
            
        } else if passwordRegisterTextField.text != verifyPasswordTextField.text {
            AlertView.shared.showAlert(fromController: self, withTitle: "Password missmatch", message: "Please provide and verify valid password")
            
        } else if (passwordRegisterTextField.text?.count)! < 6 {
            AlertView.shared.showAlert(fromController: self, withTitle: "Password is too short", message: "Password should be at least 6 characters long")
            
        } else {
            userImageSelection()
        }
    }
}

extension WelcomeViewController {
    
    //MARK: - Login layout mode
    func logInModeBegin() {
        loginStackView.isHidden = false
        logInTextField.isHidden = false
        loginLabel.isHidden = false
        passwordTextField.isHidden = false
        passwordLabel.isHidden = false
        
        logInButton.isHidden = true
        logInButton.isEnabled = false
        registerButton.isHidden = true
        registerButton.isEnabled = false
        
        confirmButton.isHidden = false
        confirmButton.isEnabled = true
        backLoginButton.isHidden = false
        backLoginButton.isEnabled = true
    }
    
    func logInModeEnded() {
        loginStackView.isHidden = true
        logInTextField.isHidden = true
        logInTextField.text = ""
        loginLabel.isHidden = true
        passwordTextField.isHidden = true
        passwordTextField.text = ""
        passwordLabel.isHidden = true
        
        logInButton.isHidden = false
        logInButton.isEnabled = true
        registerButton.isHidden = false
        registerButton.isEnabled = true
        
        confirmButton.isHidden = true
        confirmButton.isEnabled = false
        backLoginButton.isHidden = true
        backLoginButton.isEnabled = false
    }
    
    //MARK: - Register layout mode
    func registerModeBegin() {
        registrationStackView.isHidden = false
        loginRegisterLabel.isHidden = false
        loginRegisterTextField.isHidden = false
        passwordRegisterLabel.isHidden = false
        passwordRegisterTextField.isHidden = false
        verifyPasswordLabel.isHidden = false
        verifyPasswordTextField.isHidden = false
        
        logInButton.isHidden = true
        logInButton.isEnabled = false
        registerButton.isHidden = true
        registerButton.isEnabled = false
        
        nextRegisterButton.isHidden = false
        nextRegisterButton.isEnabled = true
        backRegisterButton.isHidden = false
        backRegisterButton.isEnabled = true
    }
    
    func registerModeEnded() {
        registrationStackView.isHidden = true
        loginRegisterLabel.isHidden = true
        loginRegisterTextField.isHidden = true
        loginRegisterTextField.text = ""
        passwordRegisterLabel.isHidden = true
        passwordRegisterTextField.isHidden = true
        passwordRegisterTextField.text = ""
        verifyPasswordLabel.isHidden = true
        verifyPasswordTextField.isHidden = true
        verifyPasswordTextField.text = ""
        
        logInButton.isHidden = false
        logInButton.isEnabled = true
        registerButton.isHidden = false
        registerButton.isEnabled = true
        
        nextRegisterButton.isHidden = true
        nextRegisterButton.isEnabled = false
        backRegisterButton.isHidden = true
        backRegisterButton.isEnabled = false
    }
    
    //MARK: - Image selection layout mode
    func userImageSelection() {
        registrationStackView.isHidden = true
        loginRegisterLabel.isHidden = true
        loginRegisterTextField.isHidden = true
        passwordRegisterLabel.isHidden = true
        passwordRegisterTextField.isHidden = true
        verifyPasswordLabel.isHidden = true
        verifyPasswordTextField.isHidden = true
        
        userImageView.isHidden = false
        chooseImageButton.isHidden = false
        chooseImageButton.isEnabled = true
        chooseImageButton.layer.borderWidth = 1
        chooseImageButton.layer.borderColor = UIColor.white.cgColor
        chooseImageButton.layer.cornerRadius = chooseImageButton.frame.width / 2
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        
        nextRegisterButton.isHidden = true
        nextRegisterButton.isEnabled = false
        backRegisterButton.isHidden = true
        backRegisterButton.isEnabled = false
        
        backUserImageButton.isHidden = false
        backUserImageButton.isEnabled = true
        
        submitButton.isHidden = false
        submitButton.isEnabled = true
    }
    
    func userImageSelectionEnded() {
        registrationStackView.isHidden = false
        loginRegisterLabel.isHidden = false
        loginRegisterTextField.isHidden = false
        passwordRegisterLabel.isHidden = false
        passwordRegisterTextField.isHidden = false
        verifyPasswordLabel.isHidden = false
        verifyPasswordTextField.isHidden = false
        
        logInButton.isHidden = true
        logInButton.isEnabled = false
        registerButton.isHidden = true
        registerButton.isEnabled = false
        
        userImageView.image = nil
        userImageView.isHidden = true
        chooseImageButton.isHidden = true
        chooseImageButton.isEnabled = false
        
        nextRegisterButton.isHidden = false
        nextRegisterButton.isEnabled = true
        backRegisterButton.isHidden = false
        backRegisterButton.isEnabled = true
        
        backUserImageButton.isHidden = true
        backUserImageButton.isEnabled = false
        
        submitButton.isHidden = true
        submitButton.isEnabled = false
    }
}
