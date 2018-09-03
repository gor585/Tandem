//
//  ToDoViewController.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 07.07.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import ChameleonFramework

class ToDoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterDoneButton: UISegmentedControl!
    @IBOutlet weak var addItemButton: UIBarButtonItem!
    @IBOutlet weak var filterUsersButton: UIBarButtonItem!
    @IBOutlet weak var currentUserFilterButton: UIButton!
    @IBOutlet weak var allUsersFilterButton: UIButton!
    @IBOutlet weak var userFilterStackView: UIStackView!
    
    var itemArray = [Item]()
    var allRetrievedItemsArray = [Item]()
    var usersArray = [String]()
    var currentUserItems = [Item]()
    var specifiedUserItemsDictionary = [String: [Item]]()
    var selectedCell: Item?
    let itemsDatabase = Database.database().reference().child("Items")
    let usersDatabase = Database.database().reference().child("Users")
    let currentUserName = Auth.auth().currentUser!.email
    let imageCache = ImageCache.sharedCache
    let userDefaults = UserDefaults.standard
    var lightColorTheme: Bool = true
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        userFilterUnabled()
        retrieveItems()
        createObservers()
        
        loadColorThemeSetting()
    }
    
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
            if usersArray.contains(item.userLogin) == false && item.userLogin != Auth.auth().currentUser?.email {
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
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            print("\(item.title ?? "") deleted")
            self.itemsDatabase.child(item.id).removeValue()
            //Updating values in filter arrays & dictionary by item.id
            self.itemArray = self.itemArray.filter {$0.id != item.id}
            self.allRetrievedItemsArray = self.allRetrievedItemsArray.filter {$0.id != item.id}
            self.currentUserItems = self.currentUserItems.filter {$0.id != item.id}
            self.specifiedUserItemsDictionary.updateValue(self.allRetrievedItemsArray.filter {$0.userLogin == item.userLogin}, forKey: item.userLogin)
            self.tableView.reloadData()
        }
        
        var done = UITableViewRowAction(style: .default, title: "Done") { (action, indexPath) in
            item.done = true
            self.itemsDatabase.child(item.id).updateChildValues(["IsDone": "true"])
            self.tableView.reloadData()
        }
        
        let unDone = UITableViewRowAction(style: .default, title: "Undone") { (action, indexPath) in
            item.done = false
            self.itemsDatabase.child(item.id).updateChildValues(["IsDone": "false"])
            self.tableView.reloadData()
        }
        
        if item.done == true {
            done = unDone
        }
        
        done.backgroundColor = UIColor(hexString: "008080")
        unDone.backgroundColor = UIColor(hexString: "FFCC66")
        delete.backgroundColor = UIColor(hexString: "800000")
        
        return [delete, done]
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
