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
    
    var itemArray = [Item]()
    var selectedCell: Item?
    let itemsDatabase = Database.database().reference().child("Items")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.retrieveItems()
            print("RETRIEVED DATA !!!!!!!!")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! ToDoCell
        
        cell.userImage.image = itemArray[indexPath.row].userImage
        cell.titleLabel.text = itemArray[indexPath.row].title
        cell.userLoginLabel.text = itemArray[indexPath.row].userLogin
        cell.dateLabel.text = itemArray[indexPath.row].date
        
//        if cell.userLoginLabel.text == Auth.auth().currentUser?.email as String! {
//            cell.userLoginLabel.textColor = UIColor(hexString: "008080")
//        } else {
//            cell.userLoginLabel.textColor = UIColor(hexString: "800000")
//        }
        
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
        
        //itemArray.sort { $0.date > $1.date }
        
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
            self.itemArray.remove(at: indexPath.row)
            self.itemsDatabase.child(item.id).removeValue()
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
}
