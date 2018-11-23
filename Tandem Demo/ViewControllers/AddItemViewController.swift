//
//  AddItemViewController.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 08.07.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit
import MapKit

class AddItemViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textTextField: UITextView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var textButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    
    var delegate: AddItem?
    var lightColorTheme: Bool = true
    
    var itemLatitude = ""
    var itemLongitude = ""
    var itemAddress = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        applyColorTheme()
        titleTextField.delegate = self
        textTextField.delegate = self
        activityIndicator.isHidden = true
        //Set text field buttons selected
        textButton.backgroundColor = UIColor(hexString: "008080")
        textButton.isSelected = true
        
        activityIndicator.stopAnimating()
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
    
    @IBAction func textButtonPressed(_ sender: UIButton) {
        textButton.backgroundColor = UIColor(hexString: "008080")
        cameraButton.backgroundColor = UIColor.clear
        mapButton.backgroundColor = UIColor.clear
        
        textTextField.isHidden = false
        photoImageView.isHidden = true
        mapView.isHidden = true
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        textButton.backgroundColor = UIColor.clear
        cameraButton.backgroundColor = UIColor(hexString: "008080")
        mapButton.backgroundColor = UIColor.clear
        
        textTextField.isHidden = true
        photoImageView.isHidden = false
        mapView.isHidden = true
        
        chooseImage()
    }
    
    @IBAction func mapButtonPressed(_ sender: UIButton) {
        textButton.backgroundColor = UIColor.clear
        cameraButton.backgroundColor = UIColor.clear
        mapButton.backgroundColor = UIColor(hexString: "008080")
        
        textTextField.isHidden = true
        photoImageView.isHidden = true
        mapView.isHidden = false
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        DataService.shared.getUserImg { (user, image, url) in
            guard let userName = user, let userImage = image, let userImageURL = url else { return }
            //guard let title = self.titleTextField.text, let text = self.titleTextField.text, let image = self.photoImageView.image else { return }
            
            if self.photoImageView.image != nil {
                DataService.shared.uploadItemImageToStorage(itemTitle: self.titleTextField.text!, itemImage: self.photoImageView.image!, completion: { (imageURLString) in
                    guard let imageURL = imageURLString else { return }
                    self.delegate?.userAddedNewItem(title: self.titleTextField.text!, text: self.textTextField.text!, imageURL: imageURL, latitude: self.itemLatitude, longitude: self.itemLongitude, userLogin: userName, userImage: userImage, userImgURL: userImageURL)
                })
            } else {
                self.delegate?.userAddedNewItem(title: self.titleTextField.text!, text: self.textTextField.text!, imageURL: "", latitude: self.itemLatitude, longitude: self.itemLongitude, userLogin: userName, userImage: userImage, userImgURL: userImageURL)
            }
            
            self.navigationController?.popViewController(animated: true)
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
}

//MARK: - Item Coordinates
extension AddItemViewController: ItemCoordinates {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMapMarker" {
            guard let mapVC = segue.destination as? MapViewController else { return }
            mapVC.delegate = self
        }
    }
    
    func itemCoordinates(latitude: String, longitude: String, address: String) {
        itemLatitude = latitude
        itemLongitude = longitude
        setUpMapView(latitude: latitude, longitude: longitude)
        itemAddress = address
        textTextField.text = textTextField.text + "\n\n\(address)"
    }
    
    //MARK: - MapView Setup
    func setUpMapView(latitude: String, longitude: String) {
        guard let latitude = Double(latitude) else { return }
        guard let longitude = Double(longitude) else { return }
        let itemCoordinateDisplay = CLLocationCoordinate2DMake(latitude, longitude)
        
        var span = MKCoordinateSpan()
        span.latitudeDelta = 0.07
        span.longitudeDelta = 0.07
        let region = MKCoordinateRegion(center: itemCoordinateDisplay, span: span)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapView.addAnnotation(annotation)
        mapView.showAnnotations([annotation], animated: true)
        
        mapView.showsUserLocation = true
        mapView.centerCoordinate = itemCoordinateDisplay
        mapView.setRegion(region, animated: true)
    }
}

//MARK: - Image Picker
extension AddItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        photoImageView.image = pickedImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
