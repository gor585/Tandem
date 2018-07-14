//
//  DateConverter.swift
//  Tandem Demo
//
//  Created by Jaroslav Stupinskyi on 08.07.18.
//  Copyright © 2018 Jaroslav Stupinskyi. All rights reserved.
//

import UIKit

extension Item {
    func dateString(dateToString: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm dd.MM.yyyy"
        let stringDate = dateFormatter.string(from: dateToString)
        
        return stringDate
    }
}
