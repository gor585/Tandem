//
//  Segues.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 13.07.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

extension ToDoViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addInfo" {
            let addItemVc = segue.destination as! AddItemViewController
            addItemVc.delegate = self
        }
        if segue.identifier == "toDetails" {
            let detailsVC = segue.destination as! DetailsViewController
        }
    }
}
