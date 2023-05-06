//
//  Article.swift
//  leboncoin
//
//  Created by Nicolas on 01/05/2023.
//

import Foundation


struct Article {
    let id: Int64
    let title: String
    let category: Category?
    let creationDate: Date
    let description: String
    let isUrgent: Bool
    let imagesUrl: ImageUrl
    let price: Float
    let siret: String?
    
}

extension Article {
    
    struct ImageUrl {
        let small: String?
        let thumb: String?
    }
}

extension Article: Equatable {
    static func == (lhs: Article, rhs: Article) -> Bool {
        return lhs.id == rhs.id
            && lhs.title == rhs.title
            && lhs.category == rhs.category
            && lhs.creationDate == rhs.creationDate
            && lhs.description == rhs.description
            && lhs.isUrgent == rhs.isUrgent
            && lhs.imagesUrl == rhs.imagesUrl
            && lhs.price == rhs.price
            && lhs.siret == rhs.siret
    }
}

extension Article.ImageUrl: Equatable {
    static func == (lhs: Article.ImageUrl, rhs: Article.ImageUrl) -> Bool {
        return lhs.small == rhs.small && lhs.thumb == rhs.thumb
    }
}


