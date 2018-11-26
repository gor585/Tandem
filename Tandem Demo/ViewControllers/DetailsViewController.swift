//
//  DetailsViewController.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 11.07.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var detailsTitleLabel: UILabel!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var detailsMapView: MKMapView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var textButton: UIButton!
    @IBOutlet weak var photoAlbumButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var detailsMenuStackView: UIStackView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var detailsTandemImageView: UIImageView!
    
    @IBOutlet weak var editTitleTextField: UITextField!
    @IBOutlet weak var editImageView: UIImageView!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var EditTextView: UITextView!
    @IBOutlet weak var editPhotoView: UIImageView!
    @IBOutlet weak var changeImageButton: UIButton!
    @IBOutlet weak var editMapView: MKMapView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var editTextButton: UIButton!
    @IBOutlet weak var editPhotoButton: UIButton!
    @IBOutlet weak var editMapButton: UIButton!
    @IBOutlet weak var editMenuStackView: UIStackView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var editTandemImageView: UIImageView!
    
    var delegate: EditItem?
    var cell: Item?
    var selectedItem: Int?
    var lightColorTheme = Bool()
    var usersCurrentLatitude = 0.0
    var usersCurrentLongitude = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsMapView.delegate = self
        editMapView.delegate = self
        LocationService.shared.delegate = self
        LocationService.shared.locationManager.startUpdatingLocation()
        
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        applyColorTheme()
        editTitleTextField.delegate = self
        EditTextView.delegate = self 
        
        detailsTitleLabel.text = cell?.title
        detailsTextView.text = cell?.text
        
        editTitleTextField.text = cell?.title
        EditTextView.text = cell?.text
        //Set text field buttons selected
        textButton.backgroundColor = UIColor(hexString: "008080")
        textButton.isSelected = true
        editTextButton.backgroundColor = UIColor(hexString: "008080")
        editTextButton.isSelected = true
        
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
    
    //MARK: - Details Menu Selection
    @IBAction func textButtonSelected(_ sender: UIButton) {
        textButton.backgroundColor = UIColor(hexString: "008080")
        photoAlbumButton.backgroundColor = UIColor.clear
        mapButton.backgroundColor = UIColor.clear
        
        detailsTextView.isHidden = false
        detailsImageView.isHidden = true
        detailsMapView.isHidden = true
        detailsTandemImageView.alpha = 1
        addressLabel.isHidden = true
        distanceLabel.isHidden = true
    }
    
    @IBAction func photoAlbumSelected(_ sender: UIButton) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        textButton.backgroundColor = UIColor.clear
        photoAlbumButton.backgroundColor = UIColor(hexString: "008080")
        mapButton.backgroundColor = UIColor.clear
        
        detailsTextView.isHidden = true
        detailsImageView.isHidden = false
        detailsMapView.isHidden = true
        detailsTandemImageView.alpha = 1
        addressLabel.isHidden = true
        distanceLabel.isHidden = true
        
        //Loading image from Storage or Cache
        guard let imageURL = cell?.imageURL else { return }
        guard let title = cell?.title else { return }
        
        if imageURL != "" {
            if ImageCache.sharedCache.object(forKey: title as NSString) == nil {
                DataService.shared.loadItemImageFromStorage(imageURL: imageURL, completion: { (image) in
                    guard let loadedImage = image else { return }
                    DispatchQueue.main.async {
                        self.detailsImageView.image = loadedImage
                        self.editPhotoView.image = loadedImage
                        //Add loaded image to Cache
                        ImageCache.sharedCache.setObject(loadedImage, forKey: title as NSString)
                    }
                })
            } else {
                detailsImageView.image = ImageCache.sharedCache.object(forKey: title as NSString)
                editPhotoView.image = ImageCache.sharedCache.object(forKey: title as NSString)
            }
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        } else {
            if ImageCache.sharedCache.object(forKey: title as NSString) == nil {
                detailsImageView.image = UIImage(named: "camera")
                editPhotoView.image = UIImage(named: "camera")
            } else {
                detailsImageView.image = ImageCache.sharedCache.object(forKey: title as NSString)
                editPhotoView.image = ImageCache.sharedCache.object(forKey: title as NSString)
            }
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        }
    }
    
    @IBAction func mapButtonSelected(_ sender: UIButton) {
        textButton.backgroundColor = UIColor.clear
        photoAlbumButton.backgroundColor = UIColor.clear
        mapButton.backgroundColor = UIColor(hexString: "008080")
        
        detailsTextView.isHidden = true
        detailsImageView.isHidden = true
        detailsMapView.isHidden = false
        detailsTandemImageView.alpha = 0
        addressLabel.isHidden = false
        distanceLabel.isHidden = false
    }
    
    //MARK: - Edit Menu Selection
    @IBAction func editTextButtonSelected(_ sender: UIButton) {
        editTextButton.backgroundColor = UIColor(hexString: "008080")
        editPhotoButton.backgroundColor = UIColor.clear
        editMapButton.backgroundColor = UIColor.clear
        
        EditTextView.isHidden = false
        editPhotoView.isHidden = true
        changeImageButton.isHidden = true
        changeImageButton.isEnabled = false
        editMapView.isHidden = true
        editTandemImageView.alpha = 1
        detailsTandemImageView.alpha = 1
        addressLabel.isHidden = true
        distanceLabel.isHidden = true
    }
    
    @IBAction func editPhotoButtonSelected(_ sender: UIButton) {
        editTextButton.backgroundColor = UIColor.clear
        editPhotoButton.backgroundColor = UIColor(hexString: "008080")
        editMapButton.backgroundColor = UIColor.clear
        
        EditTextView.isHidden = true
        editPhotoView.isHidden = false
        changeImageButton.isHidden = false
        changeImageButton.isEnabled = true
        editMapView.isHidden = true
        editTandemImageView.alpha = 1
        detailsTandemImageView.alpha = 1
        addressLabel.isHidden = true
        distanceLabel.isHidden = true
    }
    
    @IBAction func editMapButtonSelected(_ sender: UIButton) {
        editTextButton.backgroundColor = UIColor.clear
        editPhotoButton.backgroundColor = UIColor.clear
        editMapButton.backgroundColor = UIColor(hexString: "008080")
        
        EditTextView.isHidden = true
        editPhotoView.isHidden = true
        changeImageButton.isHidden = true
        changeImageButton.isEnabled = false
        editMapView.isHidden = false
        editTandemImageView.alpha = 0
        detailsTandemImageView.alpha = 0
        addressLabel.isHidden = false
        distanceLabel.isHidden = false
    }
    
    //MARK: - New Image Selection
    @IBAction func changeImageButtonPressed(_ sender: UIButton) {
        chooseImage()
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
            
            //Deleting item image from Storage
            guard let imageTitle = self.cell?.title else { return }
            DataService.shared.deleteItemImageInStorage(itemImage: imageTitle, completion: {})
        })
        let actionCancel = UIAlertAction(title: "Cancel", style: .default) { (actionCancel) in }
        
        alert.addAction(actionCancel)
        alert.addAction(actionDelete)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Apply changes", message: "Are you shure you want to apply changes to this item?", preferredStyle: .alert)
        let actionApply = UIAlertAction(title: "Apply", style: .default, handler: { (actionOk) in
            guard let title = self.cell?.title else { print("no title"); return }
            guard let id = self.cell?.id else { print("no id"); return }
            
            var image = UIImage()
            if self.editPhotoView.image != nil {
                image = self.editPhotoView.image!
            } else {
                image = UIImage(named: "camera-1")!
            }
            
            if self.detailsImageView.image == nil {
                DataService.shared.uploadItemImageToStorage(itemTitle: title, itemImage: image, completion: { (imageURL) in
                    guard let imageURLString = imageURL else { return }
                    print(imageURLString)
                    DataService.shared.updateImageURLInDatabase(itemID: id, newImageURL: imageURLString, completion: {})
                })
            } else {
                //Checking if new image and title are different from original (for key identification in Storage)
                if (self.editPhotoView.image != self.detailsImageView.image) && (self.detailsTitleLabel.text == self.editTitleTextField.text) {
                    DataService.shared.replaceItemImageWithNewOne(itemTitle: title, newImage: image, completion: {})
                } else if (self.editPhotoView.image != self.detailsImageView.image) && (self.detailsTitleLabel.text != self.editTitleTextField.text) {
                    DataService.shared.uploadItemImageToStorage(itemTitle: title, itemImage: image, completion: { (imageURL) in
                        guard let imageURLString = imageURL else { return }
                        print(imageURLString)
                        DataService.shared.updateImageURLInDatabase(itemID: id, newImageURL: imageURLString, completion: {})
                    })
                }
            }
            //Adding edited image to Cache
            ImageCache.sharedCache.setObject(image, forKey: title as NSString)
            
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

//MARK: - Image Picker
extension DetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        editPhotoView.image = pickedImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - MapView & LocationData delegate methods
extension DetailsViewController: MKMapViewDelegate, LocationData, ItemCoordinates {
    func getLocationData(lat: String, long: String) {
        guard let lat = Double(lat) else { return }
        guard let long = Double(long) else { return }
        usersCurrentLatitude = lat
        usersCurrentLongitude = long
        
        guard let cellLat = cell?.latitude else { return }
        guard let cellLong = cell?.longitude else { return }
        guard let latitude = Double(cellLat) else { return }
        guard let longitude = Double(cellLong) else { return }
        setUpMapView(latitude: latitude, longitude: longitude)
    }
    
    func setUpMapView(latitude: Double, longitude: Double) {
        let itemLocationDisplay = CLLocationCoordinate2DMake(latitude, longitude)
        
        var span = MKCoordinateSpan()
        span.latitudeDelta = 0.07
        span.latitudeDelta = 0.07
        let region = MKCoordinateRegion(center: itemLocationDisplay, span: span)
        
        //Mark event location
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        //MARK: - Get distance value from current location to event location
        let currentUsersLocation = CLLocation(latitude: usersCurrentLatitude, longitude: usersCurrentLongitude)
        let eventLocation = CLLocation(latitude: latitude, longitude: longitude)
        LocationService.shared.getDistance(currentLocation: currentUsersLocation, eventLocation: eventLocation) { (distance) in
            guard let distance = distance else { return }
            self.distanceLabel.text = "Distance: \(distance) km"
        }
        
        detailsMapView.centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude)
        detailsMapView.showsUserLocation = true
        detailsMapView.addAnnotation(annotation)
        detailsMapView.showAnnotations([annotation], animated: true)
        detailsMapView.setRegion(region, animated: true)
        
        editMapView.centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude)
        editMapView.showsUserLocation = true
        editMapView.addAnnotation(annotation)
        editMapView.showAnnotations([annotation], animated: true)
        editMapView.setRegion(region, animated: true)
        
        //MARK: - Reverse geocoding for address
        LocationService.shared.reverseGeocoding(lat: latitude, long: longitude) { (address) in
            guard let addressDict = address else { print("no dict"); return }
            let address = addressDict["address"]
            DispatchQueue.main.async {
                if address != nil && address != "" {
                    self.addressLabel.text = "Location: \(address!)"
                } else {
                    self.addressLabel.text = "Location is unavailable"
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMapEditing" {
            guard let mapVC = segue.destination as? MapViewController else { return }
            guard let id = cell?.id else { return }
            mapVC.id = id 
            guard let lat = cell?.latitude else { return }
            guard let long = cell?.longitude else { return }
            guard let latitude = Double(lat) else { return }
            guard let longitude = Double(long) else { return }
            mapVC.latitude = latitude
            mapVC.longitude = longitude
            mapVC.isInEditingMode = true
            mapVC.delegate = self
        }
    }
    
    func itemCoordinates(latitude: String, longitude: String, address: String) {
        guard let id = cell?.id else { return }
        DataService.shared.editItemLocationProperties(id: id, latitude: latitude, longitude: longitude) {}
        //Update mapView
        guard let newLatitude = Double(latitude) else { return }
        guard let newLongitude = Double(longitude) else { return }
        setUpMapView(latitude: newLatitude, longitude: newLongitude)
    }
}

extension DetailsViewController {
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
        detailsMenuStackView.isHidden = false
        textButton.isHidden = false
        textButton.isEnabled = true
        photoAlbumButton.isHidden = false
        photoAlbumButton.isEnabled = true
        mapButton.isHidden = false
        mapButton.isEnabled = true
        
        editTitleTextField.isHidden = true
        editImageView.isHidden = true
        editView.isHidden = true
        EditTextView.isHidden = true
        editPhotoView.isHidden = true
        changeImageButton.isHidden = true
        changeImageButton.isEnabled = false
        editMapView.isHidden = true
        confirmButton.isHidden = true
        confirmButton.isEnabled = false
        editMenuStackView.isHidden = true
        editTextButton.isHidden = true
        editTextButton.isEnabled = false
        editPhotoButton.isHidden = true
        editPhotoButton.isEnabled = false
        editMapButton.isHidden = true
        editMapButton.isEnabled = false
    }
    
    func detailsModeEnded() {
        detailsTitleLabel.isHidden = true
        detailsImageView.isHidden = true
        detailsTextView.isHidden = true
        detailsImageView.isHidden = true
        detailsMapView.isHidden = true
        detailsView.isHidden = true
        editButton.isHidden = true
        editButton.isEnabled = false
        deleteButton.isHidden = true
        deleteButton.isEnabled = false
        detailsMenuStackView.isHidden = true
        textButton.isHidden = true
        textButton.isEnabled = false
        photoAlbumButton.isHidden = true
        photoAlbumButton.isEnabled = false
        mapButton.isHidden = true
        mapButton.isEnabled = false
        
        editTitleTextField.isHidden = false
        editImageView.isHidden = false
        editView.isHidden = false
        EditTextView.isHidden = false
        confirmButton.isHidden = false
        confirmButton.isEnabled = true
        editMenuStackView.isHidden = false
        editTextButton.isHidden = false
        editTextButton.isEnabled = true
        editPhotoButton.isHidden = false
        editPhotoButton.isEnabled = true
        editMapButton.isHidden = false
        editMapButton.isEnabled = true
    }
}
