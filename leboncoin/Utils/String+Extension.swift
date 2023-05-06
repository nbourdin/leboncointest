//
//  String+Extension.swift
//  leboncoin
//
//  Created by Nicolas on 05/05/2023.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
