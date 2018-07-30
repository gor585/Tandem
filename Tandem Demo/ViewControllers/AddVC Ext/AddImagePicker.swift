//
//  AddImagePicker.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 11.07.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

extension AddItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
//    func chooseImage() {
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.delegate = self
//
//        let actionSheet = UIAlertController(title: "Image Source", message: "Choose your image source", preferredStyle: .actionSheet)
//        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
//            if UIImagePickerController.isSourceTypeAvailable(.camera) {
//                imagePickerController.sourceType = .camera
//                self.present(imagePickerController, animated: true, completion: nil)
//            }
//        }))
//        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
//            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//                imagePickerController.sourceType = .photoLibrary
//                self.present(imagePickerController, animated: true, completion: nil)
//            }
//        }))
//        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//
//        self.present(actionSheet, animated: true, completion: nil)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
//        photoImageView.image = pickedImage
//        picker.dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
}
