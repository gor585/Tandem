//
//  AlertView.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 25.09.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

class AlertView: UIAlertController {
    static let shared = AlertView()
    
    func showAlert(fromController controller: UIViewController, withTitle title: String, message: String, okButtonHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "Ok", style: .default) { (actionOk) in }
        
        alert.addAction(actionOk)
        controller.present(alert, animated: true, completion: nil)
        guard okButtonHandler?(actionOk) != nil else { return }
    }
}
