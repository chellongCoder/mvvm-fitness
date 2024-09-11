//
//  DateHelper.swift
//  NYCSchools
//
//  Created by Longnn on 11/9/24.
//

import Foundation
extension Date {
    func toString(withFormat format: String = "dd/MM/yyyy HH:mm") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
