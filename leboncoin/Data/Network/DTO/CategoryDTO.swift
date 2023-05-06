//
//  CategoryDTO.swift
//  leboncoin
//
//  Created by Nicolas on 01/05/2023.
//

import Foundation


struct CategoryDTO: Decodable {
    let id: Int64
    let name: String
}

extension CategoryDTO {
    func toDomain() -> Category {
        return .init(id: id, name: name)
    }
}
