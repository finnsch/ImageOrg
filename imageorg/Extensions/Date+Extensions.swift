//
//  Date+Extensions.swift
//  imageorg
//
//  Created by Finn Schlenk on 23.10.18.
//  Copyright © 2018 Finn Schlenk. All rights reserved.
//

import Foundation

extension Date {
    init(date: NSDate) {
        self.init(timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate)
    }

    func toString(dateFormat format: String? = "dd.MM.yyyy - HH:mm") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
