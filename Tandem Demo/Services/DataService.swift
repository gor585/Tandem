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
    
    init() {}
    
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
    
    //MARK: - Load color settings
    func loadColorThemeSetting(completion: @escaping (_ lightColorTheme: Bool) -> Void) {
        guard let userName = Auth.auth().currentUser?.email else { return }
        var lightColorTheme = false
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
                        print("ToDo light is on")
                    } else {
                        lightColorTheme = false
                        print("ToDo light is off")
                    }
                    DispatchQueue.main.async {
                        completion(lightColorTheme)
                    }
                    
                })
            }
        }
    }
    
    //MARK: - Update user image
    func updateUserImage(completion: @escaping (_ user: String?, _ userImage: UIImage?) -> Void) {
        var userImage = UIImage()
        guard let userEmail = Auth.auth().currentUser?.email else { return }
        let userImageDatabase = databaseRef.child("UserImg")
        userImageDatabase.observe(.childAdded) { (snapshot) in
            guard let snapshotValue = snapshot.value as? [String: String] else { return }
            //getting all users (as keys for img url values)
            let users = snapshotValue.keys
            //separate email to prevent "." in key name
            let delimeter = "."
            let separatedEmail = userEmail.components(separatedBy: delimeter)
            let userName = separatedEmail[0]
            
            for user in users {
                if user == userName {
                    //getting img url string of current user
                    guard let userImgURLString = snapshotValue[user] else { return }
                    let userImageURL = URL(string: userImgURLString)
                    
                    //checking if image cache contains current user image & updating this image with data from userImageURL
                    if ImageCache.sharedCache.object(forKey: userEmail as NSString) != nil {
                        guard let imageData = try? Data.init(contentsOf: userImageURL!) else { return }
                        ImageCache.sharedCache.setObject(UIImage(data: imageData)!, forKey: userEmail as NSString)
                        print("\(user) image updated and added to cache")
                        
                        userImage = ImageCache.sharedCache.object(forKey: userEmail as NSString)!
                        
                        completion(userEmail, userImage)
                        
                    } else {
                        print("No matches found in cache")
                    }
                }
            }
        }
    }
    
    //MARK: - Get user img url
    func getUserImgURL(completion: @escaping (String) -> ()) {
        let userEmailReference = databaseRef.child("UserImg")
        
        guard let userEmail = Auth.auth().currentUser?.email else { return }
        let delimeter = "."
        let token = userEmail.components(separatedBy: delimeter)
        let userName = token[0]
        var url = ""
        
        userEmailReference.observe(.childAdded) { (snapshot) in
            guard let snapshotValue = snapshot.value as? [String: String] else { return }
            for (key, value) in snapshotValue {
                if key == userName {
                    url = value
                    completion(url)
                }
            }
        }
    }
    
    //MARK: - Retrieve items
    func retrieveItems(completion: @escaping (_ item: Item?) -> Void) {
        let itemsDatabase = databaseRef.child("Items")
        itemsDatabase.observe(.childAdded) { (snapshot) in
            guard let snapshotValue = snapshot.value as? [String: String] else { return }
            
            guard let user = snapshotValue["User"] else { return }
            guard let title = snapshotValue["Title"] else { return }
            guard let text = snapshotValue["Text"] else { return }
            guard let date = snapshotValue["Date"] else { return }
            guard let isDone = snapshotValue["IsDone"] else { return }
            guard let userImgURLString = snapshotValue["UserImageURL"] else { return }
            guard let id = snapshotValue["ID"] else { return }
            
            var userImage = UIImage()
            let userImgURL = URL(string: userImgURLString)
            
            //Checking if cache already contains user image
            if ImageCache.sharedCache.object(forKey: user as NSString) == nil {
                do {
                    let imageData = try Data.init(contentsOf: userImgURL!)
                    //Saving user image to cahe
                    ImageCache.sharedCache.setObject(UIImage(data: imageData)!, forKey: user as NSString)
                    print("Image of \(user) added to cache")
                } catch {
                    print("Error retrieving data from \(userImgURL!)")
                }
            } else {
                print("Cache alresdy contains \(user) image")
            }
            
            //Setting user image to cache object
            userImage = ImageCache.sharedCache.object(forKey: user as NSString)!
            
            let item = Item(title: title, image: userImage, text: text, userLogin: user, userImage: userImage, userImgURL: userImgURLString)
            item.date = date
            item.id = id
            
            if isDone == "true" {
                item.done = true
            } else {
                item.done = false
            }
            
            completion(item)
        }
    }
    
    //MARK: - Add new item
    func addNewItem(title: String, text: String, userLogin: String, userImage: UIImage, userImgURL: String, completion: @escaping ([String: String]?) -> Void) {
        let newItem = Item(title: title, text: text, userLogin: userLogin, userImage: userImage, userImgURL: userImgURL)
        
        var isDone = "false"
        
        if newItem.done == true {
            isDone = "true"
        } else {
            isDone = "false"
        }
        
        let itemsDatabase = databaseRef.child("Items")
        newItem.id = itemsDatabase.childByAutoId().key
        print("ID: \(newItem.id)")
        
        guard let newItemDict = ["User": Auth.auth().currentUser?.email, "UserImageURL": newItem.userImgURL, "Title": newItem.title, "Text": newItem.text, "Date": newItem.date, "IsDone": isDone, "ID": newItem.id] as? [String: String] else { return }
        
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
}

