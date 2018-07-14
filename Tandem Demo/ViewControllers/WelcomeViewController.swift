//
//  ViewController.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 07.07.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit
import Firebase
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func logInButtonPressed(_ sender: Any) {
        logInModeBegin()
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
        
        if logInTextField.text == "" {
            let alert = UIAlertController(title: "Login is incorrect", message: "Please provide your correct e-mail adress", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Ok", style: .default, handler: { (actionOk) in })
            
            alert.addAction(actionOk)
            present(alert, animated: true, completion: nil)
            
        } else if passwordTextField.text == "" {
            let alert = UIAlertController(title: "Password is incorrect", message: "Please provide valid password", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Ok", style: .default, handler: { (actionOk) in })
            
            alert.addAction(actionOk)
            present(alert, animated: true, completion: nil)
            
        } else {
            Auth.auth().signIn(withEmail: logInTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                if error != nil {
                    print("Error signing in: \(error!)")
                } else {
                    SVProgressHUD.dismiss()
                    self.performSegue(withIdentifier: "toApp", sender: self)
                    print("Log in is successfull")
                    self.logInModeEnded()
                }
            })
        }
    }
    
    @IBAction func nextRegisterButtonPressed(_ sender: Any) {
        
        if loginRegisterTextField.text == "" {
            let alert = UIAlertController(title: "Login is incorrect", message: "Please provide your correct e-mail adress", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Ok", style: .default, handler: { (actionOk) in })
            
            alert.addAction(actionOk)
            present(alert, animated: true, completion: nil)
            
        } else if loginRegisterTextField.text?.contains("@") == false {
            let alert = UIAlertController(title: "Incorrect e-mail", message: "The e-mail adress is badly formatted", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Ok", style: .default, handler: { (actionOk) in })
            
            alert.addAction(actionOk)
            present(alert, animated: true, completion: nil)
            
        } else if passwordRegisterTextField.text != verifyPasswordTextField.text {
            let alert = UIAlertController(title: "Password missmatch", message: "Please provide and verify valid password", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Ok", style: .default, handler: { (actionOk) in })
            
            alert.addAction(actionOk)
            present(alert, animated: true, completion: nil)
            
        } else if (passwordRegisterTextField.text?.count)! < 6 {
            let alert = UIAlertController(title: "Password is too short", message: "Password should be at least 6 characters", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Ok", style: .default, handler: { (actionOk) in })
            
            alert.addAction(actionOk)
            present(alert, animated: true, completion: nil)
            
        } else {
            userImageSelection()
        }
    }
    
    @IBAction func backUserImageButtonPressed(_ sender: Any) {
        userImageSelectionEnded()
    }
    
    @IBAction func chooseImageButtonPressed(_ sender: Any) {
        chooseImage()
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        
        SVProgressHUD.show()
        
        if userImageView.image == nil {
            let alert = UIAlertController(title: "No photo provided", message: "Please choose an image for your profile", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Ok", style: .default, handler: { (actionOk) in })
            
            alert.addAction(actionOk)
            present(alert, animated: true, completion: nil)
            
        } else {
            Auth.auth().createUser(withEmail: self.loginRegisterTextField.text!, password: self.passwordRegisterTextField.text!) { (user, error) in
                if error != nil {
                    print("Error occured: \(error!)")
                } else {
                    print("Registration of \(user!) is successfull")
                }
            }
            
            SVProgressHUD.dismiss()
            
            performSegue(withIdentifier: "toApp", sender: self)
            userImageSelectionEnded()
            registerModeEnded()
        }
    }
    
    @IBAction func unwindToWelcomeVC(segue: UIStoryboardSegue) {}
}

