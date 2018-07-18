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
        
        titleTextField.delegate = self
        textTextField.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        
        addImageButton.layer.borderColor = UIColor.white.cgColor
        addImageButton.layer.borderWidth = 1
    }
    
    func getUserImgURL(completion: @escaping (String) -> ()) {
        let userEmailReference = Database.database().reference().child("UserImg")
        let userEmail = Auth.auth().currentUser!.email!
        let delimeter = "."
        let token = userEmail.components(separatedBy: delimeter)
        let userName = token[0]
        var url = ""
        
        userEmailReference.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            for (key, value) in snapshotValue {
                if key == userName {
                    url = value
                    completion(url)
                }
            }
        }
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        
        var userImage = UIImage()
        getUserImgURL { (url) in
            let userImgURL = URL(string: url)
            
            do {
                let imageData = try Data.init(contentsOf: userImgURL!)
                userImage = UIImage(data: imageData)!
            } catch {
                print("Error retrieving data from \(url)")
            }
            
            self.delegate?.userAddedNewItem(title: self.titleTextField.text!, image: self.photoImageView.image!, text: self.textTextField.text!, userLogin: (Auth.auth().currentUser?.email)!, userImage: userImage, userImgURL: url)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func addImageButtonPressed(_ sender: Any) {
        chooseImage()
    }
    
}
