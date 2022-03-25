//
//  NSDate+Extension.swift
//  MapShroom
//
//  Created by Андрей on 25.03.2022.
//

import Foundation

extension NSDate {
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: self as Date)
    }
}
