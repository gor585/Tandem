//
//  DesignableTextField.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 02.01.19.
//  Copyright © 2019 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableTextField: UITextField {
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let image = leftImage {
            leftViewMode = .always
            let imageView = UIImageView(frame: CGRect(x: 10, y: 5, width: 30, height: 30))
            imageView.image = image
            //Add view for image view placement and additional left side padding
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            view.addSubview(imageView)
            leftView = view
        } else {
            leftViewMode = .never
        }
    }
}
