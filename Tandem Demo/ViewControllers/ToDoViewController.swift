//
//  ToDoViewController.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 07.07.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit
import ChameleonFramework

class ToDoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterDoneButton: UISegmentedControl!
    @IBOutlet weak var addItemButton: UIBarButtonItem!
    @IBOutlet weak var filterUsersButton: UIBarButtonItem!
    @IBOutlet weak var currentUserFilterButton: UIButton!
    @IBOutlet weak var allUsersFilterButton: UIButton!
    @IBOutlet weak var userFilterStackView: UIStackView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var itemArray = [Item]()
    var allRetrievedItemsArray = [Item]()
    var usersArray = [String]()
    var currentUserItems = [Item]()
    var specifiedUserItemsDictionary = [String: [Item]]()
    var selectedCell: Item?
    
    let userDefaults = UserDefaults.standard
    var lightColorTheme = Bool()
    var currentUser: String?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        userFilterUnabled()
        
        activityIndicator.startAnimating()
        DataService.shared.retrieveItems { (currentUser, item) in
            if let currentUser = currentUser, let item = item {
                self.itemArray.append(item)
                self.allRetrievedItemsArray.append(item)
                self.currentUser = currentUser
                self.tableView.reloadData()
                self.currentUserItems = self.itemArray.filter {$0.userLogin == self.currentUser}
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            }
        }
        
        createObservers()
    }
    
    //MARK: - TableView delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! ToDoCell
        //Applying selected color theme to tableview cells
        applyColorThemeToCells(cell: cell)
        
        cell.userImage.image = itemArray[indexPath.row].userImage
        cell.titleLabel.text = itemArray[indexPath.row].title
        cell.userLoginLabel.text = itemArray[indexPath.row].userLogin
        cell.dateLabel.text = itemArray[indexPath.row].date
        
        cell.itemView.layer.cornerRadius = 15
        cell.itemView.layer.borderWidth = 1
        cell.userImage.layer.borderWidth = 1
        
        cell.userImage.layer.cornerRadius = cell.userImage.frame.height / 2
        
        if itemArray[indexPath.row].done == true {
            cell.itemView.layer.borderColor = UIColor(hexString: "008080").cgColor
            cell.itemView.backgroundColor = UIColor(hexString: "008080")
            cell.userImage.layer.borderColor = UIColor(hexString: "008080").cgColor
        } else {
            cell.itemView.layer.borderColor = UIColor(hexString: "800000").cgColor
            cell.itemView.backgroundColor = UIColor(hexString: "800000")
            cell.userImage.layer.borderColor = UIColor(hexString: "800000").cgColor
        }
        
        selectedCell = itemArray[indexPath.row]
        
        for item in itemArray {
            if usersArray.contains(item.userLogin) == false && item.userLogin != currentUser {
                usersArray.append(item.userLogin)
                stackFilterAppendUsers()
                print("\(item.userLogin)")
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let item = itemArray[indexPath.row]
        
        //MARK: - Delete item at row index
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            print("\(item.title ?? "") deleted")
            
            DataService.shared.deleteItem(id: item.id, completion: {
                //Updating values in filter arrays & dictionary by item.id
                self.itemArray = self.itemArray.filter {$0.id != item.id}
                self.allRetrievedItemsArray = self.allRetrievedItemsArray.filter {$0.id != item.id}
                self.currentUserItems = self.currentUserItems.filter {$0.id != item.id}
                self.specifiedUserItemsDictionary.updateValue(self.allRetrievedItemsArray.filter {$0.userLogin == item.userLogin}, forKey: item.userLogin)
                self.tableView.reloadData()
                //Deleting item image from Storage
                guard let imageTitle = item.title else { return }
                DataService.shared.deleteItemImageInStorage(itemImage: imageTitle, completion: {})
            })
        }
        
        //MARK: - Done/unDone
        var done = UITableViewRowAction(style: .default, title: "Done") { (action, indexPath) in
            item.done = true
            DataService.shared.updateDone(id: item.id, isDone: item.done, completion: {
                self.tableView.reloadData()
            })
        }
        
        let unDone = UITableViewRowAction(style: .default, title: "Undone") { (action, indexPath) in
            item.done = false
            DataService.shared.updateDone(id: item.id, isDone: item.done, completion: {
                self.tableView.reloadData()
            })
        }
        
        if item.done == true {
            done = unDone
        }
        
        done.backgroundColor = UIColor(hexString: "008080")
        unDone.backgroundColor = UIColor(hexString: "FFCC66")
        delete.backgroundColor = UIColor(hexString: "800000")
        
        return [delete, done]
    }
    
    //MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addInfo" {
            let addItemVc = segue.destination as! AddItemViewController
            addItemVc.delegate = self
            //Applying selected color theme
            addItemVc.lightColorTheme = lightColorTheme
        }
        if segue.identifier == "toDetails" {
            let detailsVC = segue.destination as! DetailsViewController
            detailsVC.cell = itemArray[(tableView.indexPathForSelectedRow?.row)!]
            //Applying selected color theme
            detailsVC.lightColorTheme = lightColorTheme
            detailsVC.selectedItem = tableView.indexPathForSelectedRow?.row
            detailsVC.delegate = self
        }
    }
    
    //MARK: - Filter done items
    @IBAction func filterDoneButtonPressed(_ sender: UISegmentedControl) {
        if filterDoneButton.selectedSegmentIndex == 1 {
            itemArray = itemArray.filter {$0.done == false}
            tableView.reloadData()
        } else if filterDoneButton.selectedSegmentIndex == 0 {
            itemArray = allRetrievedItemsArray
            tableView.reloadData()
        }
    }
    
    @IBAction func filterUsersButtonPressed(_ sender: Any) {
        currentUserFilterButton.isHidden == true ? userFilterEnabled() : userFilterUnabled()
    }
    
    @IBAction func currentUserFilterButtonPressed(_ sender: Any) {
        userFilterUnabled()
        itemArray = currentUserItems
        tableView.reloadData()
    }
    
    @IBAction func allUsersFilterButtonPressed(_ sender: Any) {
        userFilterUnabled()
        itemArray = allRetrievedItemsArray
        tableView.reloadData()
    }
}

//MARK: - Add item extension
extension ToDoViewController: AddItem {
    
    func userAddedNewItem(title: String, text: String, imageURL: String, latitude: String, longitude: String, userLogin: String, userImage: UIImage, userImgURL: String) {
        DataService.shared.addNewItem(title: title, text: text, imageURL: imageURL, latitude: latitude, longitude: longitude, userLogin: userLogin, userImage: userImage, userImgURL: userImgURL) { (newItemDict) in
            if newItemDict != nil {
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: - Edit/Delete item extension
extension ToDoViewController: EditItem {
    
    func userEditedItem(atIndex: Int, title: String, image: UIImage, text: String) {
        DataService.shared.editItem(id: itemArray[atIndex].id, title: title, text: text) {
            self.tableView.reloadData()
        }
    }
    
    func userDeletedItem(atIndex: Int) {
        DataService.shared.deleteItem(id: itemArray[atIndex].id) {
            self.itemArray.remove(at: atIndex)
            self.tableView.reloadData()
        }
    }
}
