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
    var lightColorTheme: Bool = true
    
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
    
}
