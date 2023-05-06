//
//  Category.swift
//  leboncoin
//
//  Created by Nicolas on 04/05/2023.
//

import Foundation

struct Category: Hashable {
    let id: Int64?
    let name: String
}

extension Category {
    static let all: Category = Category(id: nil, name: "category.all".localized)
}
