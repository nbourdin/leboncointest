//
//  ClassifiedAdDTO.swift
//  leboncoin
//
//  Created by Nicolas on 01/05/2023.
//

import Foundation

struct ClassifiedAdDTO {
    let id: Int64
    let title: String
    let categoryId: Int64
    let creationDate: Date
    let description: String
    let isUrgent: Bool
    let imagesUrl: ImageUrlDTO
    let price: Float
    let siret: String?
    
}

extension ClassifiedAdDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case categoryId = "category_id"
        case creationDate = "creation_date"
        case description
        case isUrgent = "is_urgent"
        case imagesUrl = "images_url"
        case price
        case siret
    }
    
    struct ImageUrlDTO: Decodable {
        let small: String?
        let thumb: String?
        
        func toDomain() -> Article.ImageUrl {
            return .init(small: small, thumb: thumb)
        }
    }
}

extension ClassifiedAdDTO {
    func toDomain(category: Category?) -> Article {
        return .init(id: id, title: title, category: category, creationDate: creationDate, description: description, isUrgent: isUrgent, imagesUrl: imagesUrl.toDomain(), price: price, siret: siret)
    }
}
