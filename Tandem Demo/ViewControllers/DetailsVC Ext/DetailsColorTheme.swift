//
//  DetailsColorTheme.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 13.08.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

extension DetailsViewController {
    
    func applyColorTheme() {
        switch lightColorTheme {
        case false:
            self.view.backgroundColor = UIColor(hexString: "7F7F7F")
        default:
            self.view.backgroundColor = UIColor(hexString: "E6E6E6")
        }
    }
}
