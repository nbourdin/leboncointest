//
//  Date+Extension.swift
//  leboncoin
//
//  Created by Nicolas on 05/05/2023.
//

import Foundation

extension Date {
    var formattedString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: self)
    }
}
