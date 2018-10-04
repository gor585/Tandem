//
//  DetailsViewController.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 11.07.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var detailsTitleLabel: UILabel!
    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var editTitleTextField: UITextField!
    @IBOutlet weak var editImageView: UIImageView!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var EditTextView: UITextView!
    @IBOutlet weak var confirmButton: UIButton!
    
    var delegate: EditItem?
    var cell: Item?
    var selectedItem: Int?
    var lightColorTheme = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyColorTheme()
        editTitleTextField.delegate = self
        EditTextView.delegate = self 
        
        detailsTitleLabel.text = cell?.title
        detailsTextView.text = cell?.text
        
        editTitleTextField.text = cell?.title
        EditTextView.text = cell?.text
        
        detailsModeBegin()
        self.hideKeyboardWhenTappedAround()
    }
    
    //MARK: - Color theme
    func applyColorTheme() {
        switch lightColorTheme {
        case false:
            self.view.backgroundColor = UIColor(hexString: "7F7F7F")
        default:
            self.view.backgroundColor = UIColor(hexString: "E6E6E6")
        }
    }
    
    //MARK: - Edit item
    @IBAction func editButtonPressed(_ sender: Any) {
        detailsModeEnded()
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Delete item", message: "Are you shure you want to delete this item?", preferredStyle: .alert)
        let actionDelete = UIAlertAction(title: "Delete", style: .destructive, handler: { (actionDelete) in
            self.delegate?.userDeletedItem(atIndex: self.selectedItem!)
            self.navigationController?.popViewController(animated: true)
        })
        let actionCancel = UIAlertAction(title: "Cancel", style: .default) { (actionCancel) in }
        
        alert.addAction(actionCancel)
        alert.addAction(actionDelete)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Apply changes", message: "Are you shure you want to apply changes to this item?", preferredStyle: .alert)
        let actionApply = UIAlertAction(title: "Apply", style: .default, handler: { (actionOk) in
            
            self.cell?.title = self.editTitleTextField.text
            self.cell?.image = self.editImageView.image
            self.cell?.text = self.EditTextView.text
            
            self.detailsTitleLabel.text = self.editTitleTextField.text
            self.detailsImageView.image = self.editImageView.image
            self.detailsTextView.text = self.EditTextView.text
            
            self.delegate?.userEditedItem(atIndex: self.selectedItem!, title: self.editTitleTextField.text!, image: self.editImageView.image!, text: self.EditTextView.text!)
            
            self.navigationController?.popViewController(animated: true)
            self.detailsModeBegin()
        })
        let actionCancel = UIAlertAction(title: "Cancel", style: .default) { (actionCancel) in
            self.detailsModeBegin()
        }
        
        alert.addAction(actionCancel)
        alert.addAction(actionApply)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Details mode layout
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
        confirmButton.isHidden = false
        confirmButton.isEnabled = true
    }
}
