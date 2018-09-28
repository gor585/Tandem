//
//  AddItemViewController.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 08.07.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class AddItemViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textTextField: UITextView!
    
    var delegate: AddItem?
    var lightColorTheme: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        applyColorTheme()
        titleTextField.delegate = self
        textTextField.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    
    func applyColorTheme() {
        switch lightColorTheme {
        case false:
            self.view.backgroundColor = UIColor(hexString: "7F7F7F")
        default:
            self.view.backgroundColor = UIColor(hexString: "E6E6E6")
        }
    }
        
    @IBAction func submitButtonPressed(_ sender: Any) {
        SVProgressHUD.show()
        var userImage = UIImage()
        DataService.shared.getUserImgURL { (url) in
            guard let userImgURL = URL(string: url) else { return }
            do {
                let imageData = try Data.init(contentsOf: userImgURL)
                userImage = UIImage(data: imageData)!
                self.delegate?.userAddedNewItem(title: self.titleTextField.text!, text: self.textTextField.text!, userLogin: (Auth.auth().currentUser?.email)!, userImage: userImage, userImgURL: url)
                self.navigationController?.popViewController(animated: true)
                SVProgressHUD.dismiss()
            } catch {
                print("Error retrieving data from \(url)")
            }
        }
    }
}
