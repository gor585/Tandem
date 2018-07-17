//
//  DeleteItem.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 17.07.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

extension ToDoViewController: EditItem {
    
    func userEditedItem(atIndex: Int, title: String, image: UIImage, text: String) {
        itemsDatabase.child(itemArray[atIndex].id).updateChildValues(["Title": title, "Text": text])
        tableView.reloadData()
    }
    
    func userDeletedItem(atIndex: Int) {
        itemsDatabase.child(itemArray[atIndex].id).removeValue()
        itemArray.remove(at: atIndex)
        tableView.reloadData()
    }
}
