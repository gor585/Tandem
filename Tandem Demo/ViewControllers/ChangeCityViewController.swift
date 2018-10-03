//
//  ChangeCityViewController.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 04.09.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

class ChangeCityViewController: UIViewController {
    
    @IBOutlet weak var enterCityNameLabel: UILabel!
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    var delegate: ChangeCityName?
    var lightColorTheme: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyColorTheme()
    }
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        
        if cityNameTextField.text == "" {
            let alert = UIAlertController(title: "No city name provided", message: "Please enter city name", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Ok", style: .default, handler: { (action) in })
            
            alert.addAction(actionOk)
            present(alert, animated: true, completion: nil)
            
        } else {
            guard let city = cityNameTextField.text else { return }
            delegate?.userChangedCityName(cityName: city)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func applyColorTheme() {
        switch lightColorTheme {
        case true:
            self.view.backgroundColor = UIColor(hexString: "E6E6E6")
            enterCityNameLabel.textColor = UIColor(hexString: "008080")
        case false:
            self.view.backgroundColor = UIColor(hexString: "7F7F7F")
            enterCityNameLabel.textColor = UIColor.white
        break
        }
    }
}
