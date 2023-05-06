//
//  Price.swift
//  leboncoin
//
//  Created by Nicolas on 05/05/2023.
//

import Foundation

extension Float {
    var formattedPrice: String {
        let priceStr = "\(self)"
        guard let indexToShortCurrency = priceStr.firstIndex(of: ".") else { return "\(priceStr) \("currency".localized)" }
        
        return  "\(priceStr.prefix(upTo: indexToShortCurrency)) \("currency".localized)"
    }
}
