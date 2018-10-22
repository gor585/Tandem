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

class DateConverter {
    static let shared = DateConverter()
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    let currentDateString: String = {
        return dateFormatter.string(from: Date())
    }()
    
    let nextTwoWeeksDateString: String = {
        let nextWeekDate = Calendar.current.date(byAdding: .day, value: +13, to: Date())
        return dateFormatter.string(from: nextWeekDate!)
    }()
    
    let lastTwoWeeksDateString: String = {
        let lastWeekDate = Calendar.current.date(byAdding: .day, value: -13, to: Date())
        return dateFormatter.string(from: lastWeekDate!)
    }()
}
