//
//  DataService.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 26.09.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    static let shared = DataService()
    let databaseRef = Database.database().reference()
    let userDefaults = UserDefaults.standard
    
    init() {}
    
    //MARK: - Sign in
    func signIn(withEmail email: String, password: String, completion: @escaping (_ isSuccess: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print("Error signing in: \(error!)")
                completion(false)
            } else {
                print("Log in is successfull")
                completion(true)
            }
        })
    }
    
    //MARK: - Retrieve users passwords data
    func retrieveUsersData(_ completion: @escaping ([String: String]) -> Void) {
        let usersDatabase = databaseRef.child("Users")
        var userDict = [String: String]()
        usersDatabase.observe(.childAdded) { (snapshot) in
            guard let snapshotValue = snapshot.value as? [String: String] else { return }
            guard let user = snapshotValue["User"] else { return }
            guard let password = snapshotValue["Password"] else { return }
            userDict.updateValue(password, forKey: user)
            completion(userDict)
        }
    }
    
    //MARK: - Create new user
    func createUser(withEmail: String, password: String, image: UIImage, completion: @escaping (_ userName: String?, _ password: String?, _ image: UIImage?) -> Void) {
        
        Auth.auth().createUser(withEmail: withEmail, password: password) { (user, error) in
            if error != nil {
                print("Error occured: \(error!)")
            } else {
                print("Registration of \(user!) is successfull")
            }
            
            //----Formatting user email to avoid using "@", "." etc in keys
            let delimeter = "."
            let separatedEmail = withEmail.components(separatedBy: delimeter)
            let userName = separatedEmail[0]
            
            //----Appending registered users images dictionary in Storage
            var data = NSData()
            data = UIImageJPEGRepresentation(image, 0.01)! as NSData
            
            let metadata = StorageMetadata()
            let imageStorage = Storage.storage().reference().child("images/user_profiles")
            imageStorage.child("\(withEmail).jpg").putData(data as Data, metadata: metadata) { (metadata, error) in
                guard let metadata = metadata else {
                    print("Error ocurred: \(error!)")
                    return
                }
                print("Uploaded profile image with metadata: \(metadata)")
                
                let userImgDatabase = Database.database().reference().child("UserImg")
                let userImgDictionary = ["\(userName)": "\(metadata.downloadURL()!.absoluteString)"]
                
                userImgDatabase.childByAutoId().setValue(userImgDictionary) {
                    (error, reference) in
                    if error != nil {
                        print("Error: \(error!)")
                    } else {
                        print("User image url saved successfully")
                    }
                }
            }
            
            //----Appending registered users passwords dictionary
            let usersDatabase = Database.database().reference().child("Users")
            let userID = usersDatabase.childByAutoId().key
            var usersPasswordsDictionary = [String: String]()
            usersPasswordsDictionary.updateValue(withEmail, forKey: "User")
            usersPasswordsDictionary.updateValue(password, forKey: "Password")
            usersPasswordsDictionary.updateValue(userID, forKey: "ID")
            usersPasswordsDictionary.updateValue("true", forKey: "LightColorTheme") //------> settings
            usersDatabase.child(userID).setValue(usersPasswordsDictionary)
            
            completion(userName, password, image)
        }
    }
    
    //MARK: - Upload item image to Storage
    func uploadItemImageToStorage(itemTitle: String, itemImage: UIImage, completion: @escaping (_ imageURL: String?) -> Void) {
        var data = NSData()
        data = UIImageJPEGRepresentation(itemImage, 0.05)! as NSData
        let metadata = StorageMetadata()
        let imageStorage = Storage.storage().reference().child("images/item_images")
        imageStorage.child("\(itemTitle).jpg").putData(data as Data, metadata: metadata) { (metadata, error) in
            guard let metadata = metadata else { print("Metadata error: \(error!)"); return }
            guard let imageURLString = metadata.downloadURL()?.absoluteString else { return }
            completion(imageURLString)
        }
    }
    
    //MARK: - Load item image from Storage
    func loadItemImageFromStorage(imageURL: String, completion: (_ image: UIImage?) -> Void) {
        guard let imageURL = URL(string: imageURL) else { return }
        guard let imageData = try? Data(contentsOf: imageURL) else { print("Error getting item image data"); return }
        let image = UIImage(data: imageData)!
        completion(image)
    }
    
    //MARK: - Delete item image in Storage
    func deleteItemImageInStorage(itemImage: String, completion: () -> Void) {
        let imageStorage = Storage.storage().reference().child("images/item_images")
        imageStorage.child("\(itemImage).jpg").delete(completion: nil)
    }
    
    //MARK: - Load color settings
    func loadColorThemeSetting(completion: @escaping (_ lightColorTheme: Bool?) -> Void) {
        guard let userName = Auth.auth().currentUser?.email else { return }
        var lightColorTheme = Bool()
        let usersDatabase = databaseRef.child("Users")
        usersDatabase.observe(.childAdded) { (snapshot) in
            guard let snapshotValue = snapshot.value as? [String: String] else { return }
            guard let userLogin = snapshotValue["User"] else { return }
            guard let userID = snapshotValue["ID"] else { return }
            
            if userLogin == userName {
                let colorSettingRef = usersDatabase.child(userID).child("LightColorTheme")
                colorSettingRef.observe(.value, with: { (snapshot) in
                    guard let colorSetting = snapshot.value as? String else { return }
                    if colorSetting == "true" {
                        lightColorTheme = true
                        NotificationCenter.default.post(name: COLOR_THEME_LIGHT, object: nil)
                    } else {
                        lightColorTheme = false
                        NotificationCenter.default.post(name: COLOR_THEME_DARK, object: nil)
                    }
                    self.userDefaults.set(lightColorTheme, forKey: "lightThemeIsOn")
                    completion(lightColorTheme)
                })
            }
        }
    }
    
    //MARK: - Get user img from cache
    func getUserImageFromCache(completion: @escaping (_ user: String?, _ image: UIImage?)-> Void) {
        guard let currentUserName = Auth.auth().currentUser?.email else { return }
        var userImage: UIImage?
        let imageCache = ImageCache.sharedCache
        if imageCache.object(forKey: currentUserName as NSString) != nil {
            userImage = imageCache.object(forKey: currentUserName as NSString)
            completion(currentUserName, userImage)
            print("Image of \(currentUserName) loaded from cache")
        } else {
            loadUserImageFromStorage(completion: { (image) in
                guard let image = image else { return }
                userImage = image
                print("Image loaded from Storage")
                completion(currentUserName, userImage)
            })
        }
    }
    
    //MARK: - Update user image in cache
    func updateUserImage(completion: @escaping (_ user: String?, _ userImage: UIImage?) -> Void) {
        var userImage = UIImage()
        guard let currentUserName = Auth.auth().currentUser?.email else { return }
        let userImageDatabase = databaseRef.child("UserImg")
        userImageDatabase.observe(.childAdded) { (snapshot) in
            guard let snapshotValue = snapshot.value as? [String: String] else { return }
            //getting all users (as keys for img url values)
            let users = snapshotValue.keys
            //separate email to prevent "." in key name
            let delimeter = "."
            let separatedEmail = currentUserName.components(separatedBy: delimeter)
            let userName = separatedEmail[0]
            
            for user in users {
                if user == userName {
                    //getting img url string of current user
                    guard let userImgURLString = snapshotValue[user] else { return }
                    let userImageURL = URL(string: userImgURLString)
                    
                    //checking if image cache contains current user image & updating this image with data from userImageURL
                    if ImageCache.sharedCache.object(forKey: currentUserName as NSString) != nil {
                        guard let imageData = try? Data.init(contentsOf: userImageURL!) else { return }
                        ImageCache.sharedCache.setObject(UIImage(data: imageData)!, forKey: currentUserName as NSString)
                        
                        userImage = ImageCache.sharedCache.object(forKey: currentUserName as NSString)!
                        
                        completion(currentUserName, userImage)
                        
                    } else {
                        print("No matches found in cache for \(currentUserName)")
                    }
                }
            }
        }
    }
    
    //MARK: - Get user img
    func getUserImg(completion: @escaping (_ user: String?, _ image: UIImage?, _ url: String?) -> ()) {
        let userEmailReference = databaseRef.child("UserImg")
        
        guard let userEmail = Auth.auth().currentUser?.email else { return }
        let delimeter = "."
        let token = userEmail.components(separatedBy: delimeter)
        let userName = token[0]
        var url = ""
        var userImage = UIImage()
        
        userEmailReference.observe(.childAdded) { (snapshot) in
            guard let snapshotValue = snapshot.value as? [String: String] else { return }
            for (key, value) in snapshotValue {
                if key == userName {
                    url = value
                    if ImageCache.sharedCache.object(forKey: userEmail as NSString) == nil {
                        guard let imageURL = URL(string: url) else { return }
                        do {
                            let imageData = try Data(contentsOf: imageURL)
                            userImage = UIImage(data: imageData)!
                            print("Image of \(userEmail) loaded from Storage")
                        } catch {
                            print("Error getting user image data: \(error)")
                        }
                        completion(userEmail, userImage, url)
                    } else {
                        self.getUserImageFromCache(completion: { (userName, userImage) in
                            guard let name = userName else { return }
                            guard let image = userImage else { return }
                            completion(name, image, url)
                            print("Image of \(name) loaded from cache")
                        })
                    }
                }
            }
        }
    }
    
    //MARK: - Replace user image in Storage
    func replaceUserImageWithNewOne(newImage: UIImage, completion: @escaping () -> Void) {
        guard let currentUserName = Auth.auth().currentUser?.email else { return }
        guard let data = UIImageJPEGRepresentation(newImage, 0.1) as NSData? else { return }
        let metadata = StorageMetadata()
        let imageStorage = Storage.storage().reference().child("images/user_profiles/\(currentUserName).jpg")
        imageStorage.putData(data as Data, metadata: metadata) { (metadata, error) in
            guard let metadata = metadata else {
                print("Error ocurred: \(error!)")
                return
            }
            print("Updated profile image with metadata: \(metadata)")
            completion()
            //self.sendChangedUserImageNotification()
        }
    }
    
    //MARK: - Replace item image in Storage
    func replaceItemImageWithNewOne(itemTitle: String, newImage: UIImage, completion: @escaping () -> Void) {
        guard let data = UIImageJPEGRepresentation(newImage, 0.05) as NSData? else { return }
        let metadata = StorageMetadata()
        let imageStorage = Storage.storage().reference().child("images/item_images/\(itemTitle).jpg")
        imageStorage.putData(data as Data, metadata: metadata) { (metadata, error) in
            completion()
        }
    }
    
    //MARK: - Update item image url in Database
    func updateImageURLInDatabase(itemID: String, newImageURL: String, completion: @escaping () -> Void) {
        let itemDatabaseRef = databaseRef.child("Items/\(itemID)")
        itemDatabaseRef.observe(.value) { (snapshot) in
            guard var snapshotValue = snapshot.value as? [String: String] else { return }
            if snapshotValue["ImageURL"] != nil {
                //snapshotValue["ImageURL"] = newImageURL
                itemDatabaseRef.updateChildValues(["ImageURL": newImageURL])
            } else {
                itemDatabaseRef.child("ImageURL").setValue(newImageURL)
            }
            completion()
        }
    }
    
    //MARK: - Change password
    func changePassword(password: String, newPassword: String, verifyPassword: String, viewController: UIViewController, completion: @escaping (_ newPassword: String?) -> Void) {
        guard let currentUserName = Auth.auth().currentUser?.email else { return }
        let usersDatabase = databaseRef.child("Users")
        usersDatabase.observe(.childAdded) { (snapshot) in
            guard let snapshotValue = snapshot.value as? [String: String] else { return }
            guard let userName = snapshotValue["User"] else { return }
            guard let userID = snapshotValue["ID"] else { return }
            guard let userPassword = snapshotValue["Password"] else { return }
            var oldPassword = ""
            if userName == currentUserName {
                oldPassword = userPassword
                if password == oldPassword && newPassword.count >= 6 && (newPassword == verifyPassword) {
                    Auth.auth().currentUser?.updatePassword(to: newPassword, completion: nil)
                    //Updating user password in Database
                    usersDatabase.child(userID).child("Password").setValue(newPassword)
                    print("User \(currentUserName) password is changed to \(newPassword)")
                } else if newPassword.count < 6 {
                    let alert = UIAlertController(title: "Password is to short", message: "Password should be at least 6 characters long", preferredStyle: .alert)
                    let actionOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alert.addAction(actionOk)
                    viewController.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Password missmatch", message: "Please provide correct password", preferredStyle: .alert)
                    let actionOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alert.addAction(actionOk)
                    viewController.present(alert, animated: true, completion: nil)
                }
                completion(newPassword)
            }
        }
    }
    
    //MARK: - Retrieve items
    func retrieveItems(completion: @escaping (_ currentUser: String?, _ item: Item?) -> Void) {
        guard let currentUserName = Auth.auth().currentUser?.email else { return }
        let itemsDatabase = databaseRef.child("Items")
        itemsDatabase.observe(.childAdded) { (snapshot) in
            guard let snapshotValue = snapshot.value as? [String: String] else { return }
            
            guard let user = snapshotValue["User"] else { return }
            guard let title = snapshotValue["Title"] else { return }
            guard let text = snapshotValue["Text"] else { return }
            guard let date = snapshotValue["Date"] else { return }
            guard let userImgURLString = snapshotValue["UserImageURL"] else { return }
            guard let isDone = snapshotValue["IsDone"] else { return }
            guard let id = snapshotValue["ID"] else { return }
            guard let imageURL = snapshotValue["ImageURL"] else { return }
            guard let latitude = snapshotValue["Latitude"] else { return }
            guard let longitude = snapshotValue["Longitude"] else { return }
            
            var userImage = UIImage()
            let userImgURL = URL(string: userImgURLString)
            
            //Checking if cache already contains user image
            if ImageCache.sharedCache.object(forKey: user as NSString) == nil {
                do {
                    let imageData = try Data.init(contentsOf: userImgURL!)
                    //Saving user image to cache
                    ImageCache.sharedCache.setObject(UIImage(data: imageData)!, forKey: user as NSString)
                    print("\(user) image saved to Cache")
                } catch {
                    print("Error retrieving data from \(userImgURL!)")
                }
            } 
            
            //Setting user image to cache object
            userImage = ImageCache.sharedCache.object(forKey: user as NSString)!
            
            let item = Item(title: title, image: userImage, imageURL: imageURL, text: text, latitude: latitude, longitude: longitude, userLogin: user, userImage: userImage, userImgURL: userImgURLString)
            item.date = date
            item.id = id
            
            if isDone == "true" {
                item.done = true
            } else {
                item.done = false
            }
            
            completion(currentUserName, item)
        }
    }
    
    //MARK: - Add new item
    func addNewItem(title: String, text: String, imageURL: String, latitude: String, longitude: String, userLogin: String, userImage: UIImage, userImgURL: String, completion: @escaping ([String: String]?) -> Void) {
        let newItem = Item(title: title, imageURL: imageURL, text: text, latitude: latitude, longitude: longitude, userLogin: userLogin, userImage: userImage, userImgURL: userImgURL)
        
        var isDone = "false"
        
        if newItem.done == true {
            isDone = "true"
        } else {
            isDone = "false"
        }
        
        let itemsDatabase = databaseRef.child("Items")
        newItem.id = itemsDatabase.childByAutoId().key
        print("ID: \(newItem.id)")
        
        guard let newItemDict = ["User": Auth.auth().currentUser?.email, "UserImageURL": newItem.userImgURL, "Title": newItem.title, "Text": newItem.text, "ImageURL": newItem.imageURL, "Date": newItem.date, "Latitude": newItem.latitude, "Longitude": newItem.longitude, "IsDone": isDone, "ID": newItem.id] as? [String: String] else { return }
        
        DispatchQueue.global(qos: .userInteractive).async {
            itemsDatabase.child(newItem.id).setValue(newItemDict) {
                (error, reference) in
                if error != nil {
                    print("Error: \(error!)")
                } else {
                    print("Item saved successfully")
                }
            }
        }
        completion(newItemDict)
    }
    
    //MARK: - Edit item
    func editItem(id: String, title: String, text: String, completion: () -> Void) {
        let itemsDatabase = databaseRef.child("Items")
        itemsDatabase.child(id).updateChildValues(["Title": title, "Text": text])
        completion()
    }
    
    //MARK: - Edit item location properties
    func editItemLocationProperties(id: String, latitude: String, longitude: String, completion: () -> Void) {
        let itemsDatabase = databaseRef.child("Items")
        itemsDatabase.child(id).updateChildValues(["Latitude": latitude, "Longitude": longitude])
        completion()
    }
    
    //MARK: - Delete item
    func deleteItem(id: String, completion: () -> Void) {
        let itemsDatabase = databaseRef.child("Items")
        itemsDatabase.child(id).removeValue()
        completion()
    }
    
    //MARK: - Update item done/unDone
    func updateDone(id: String, isDone: Bool, completion: () -> Void) {
        let itemsDatabase = databaseRef.child("Items")
        isDone == true ? itemsDatabase.child(id).updateChildValues(["IsDone": "true"]) : itemsDatabase.child(id).updateChildValues(["IsDone": "false"])
        completion()
    }
    
    //MARK: - Load user image from Storage
    func loadUserImageFromStorage(completion: @escaping (_ image: UIImage?) -> Void) {
        guard let currentUserName = Auth.auth().currentUser?.email else { return }
        let imageStorage = Storage.storage().reference().child("images/user_profiles/\(currentUserName).jpg")
        var image = UIImage()
        imageStorage.getMetadata { (metadata, error) in
            guard let metadata = metadata else { return }
            guard let userImageURL = metadata.downloadURL()?.absoluteURL else { return }
            do {
                let imageData = try Data.init(contentsOf: userImageURL)
                image = UIImage(data: imageData)!
            } catch {
                print("Unable to load image from \(userImageURL)")
            }
            completion(image)
        }
    }
    
    //MARK: - Save color setting
    func saveColorSettings(settingString: String, completion: @escaping () -> Void) {
        guard let currentUserName = Auth.auth().currentUser?.email else { return }
        let usersDatabase = databaseRef.child("Users")
        usersDatabase.observe(.childAdded) { (snapshot) in
            guard let snapshotValue = snapshot.value as? [String: String] else { return }
            guard let userLogin = snapshotValue["User"] else { return }
            guard let userID = snapshotValue["ID"] else { return }
            
            if userLogin == currentUserName {
                usersDatabase.child(userID).updateChildValues(["LightColorTheme": settingString])
            }
            completion()
        }
    }
    
    //MARK: - Sign out
    func signOut(vievController: UIViewController, completion: () -> Void) {
        do {
            try Auth.auth().signOut()
            completion()
        } catch {
            let alert = UIAlertController(title: "Error", message: "Could not sign out", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Ok", style: .default, handler: { (actionOk) in })
            
            alert.addAction(actionOk)
            vievController.present(alert, animated: true, completion: nil)
            print("Error while signing out")
        }
    }
}

