//
//  AddItemViewController.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 08.07.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit
import Firebase

class AddItemViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var textTextField: UITextView!
    @IBOutlet weak var addImageButton: UIButton!
    
    var delegate: AddItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addImageButton.layer.borderColor = UIColor.white.cgColor
        addImageButton.layer.borderWidth = 1
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        delegate?.userAddedNewItem(title: titleTextField.text!, image: photoImageView.image!, text: textTextField.text!, userLogin: (Auth.auth().currentUser?.email)!, userImage: photoImageView.image!)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addImageButtonPressed(_ sender: Any) {
        chooseImage()
    }
    
}
