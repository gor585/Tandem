//
//  UserFilter.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 28.07.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

extension ToDoViewController {
    
    func userFilterUnabled() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.currentUserFilterButton.isHidden = true
            self.currentUserFilterButton.isEnabled = false
            self.allUsersFilterButton.isHidden = true
            self.allUsersFilterButton.isEnabled = false
            self.userFilterStackView.isHidden = true
        })
    }
    
    func userFilterEnabled() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.currentUserFilterButton.setTitle(self.currentUser, for: .normal)
            self.currentUserFilterButton.isHidden = false
            self.currentUserFilterButton.isEnabled = true
            self.allUsersFilterButton.isHidden = false
            self.allUsersFilterButton.isEnabled = true
            self.userFilterStackView.isHidden = false
            self.view.layoutIfNeeded()
        })
    }
    
    func stackFilterAppendUsers() {
        let userNameButton = UIButton()
        for user in usersArray {
            let specifiedUserItemsArray = itemArray.filter {$0.userLogin == user}
            specifiedUserItemsDictionary.updateValue(specifiedUserItemsArray, forKey: user)
            userNameButton.addTarget(self, action: #selector(otherUserFilterButtonPressed), for: .touchUpInside)
            userNameButton.setTitle("\(user)", for: .normal)
            userNameButton.backgroundColor = UIColor(hexString: "FF6666")
            userNameButton.titleLabel!.font = UIFont(name: "System", size: 15.0)
            userFilterStackView.addArrangedSubview(userNameButton)
        }
    }
    
    @objc func otherUserFilterButtonPressed(sender: UIButton) {
        userFilterUnabled()
        itemArray = specifiedUserItemsDictionary[sender.titleLabel!.text!]!
        tableView.reloadData()
    }
}
