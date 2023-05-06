//
//  XCTestCase+Extension.swift
//  leboncoinTests
//
//  Created by Nicolas on 07/05/2023.
//

import Foundation
import XCTest
import Combine
@testable import leboncoin

extension XCTestCase {
    
    var articlesFakeDtos: [ArticleDTO] { return articlesStubs() }
    var categoriesFakeDtos: [CategoryDTO] { return categoryStubs() }
    
    var categoriesFakeEntities: [CategoryEntity] {
        return categoriesFakeDtos.map { $0.toDomain() }
    }
    var articlesFakeEntities: [ArticleEntity] {
        return articlesFakeDtos.map { article in
            article.toDomain(category: categoriesFakeEntities.first(where: { category in category.id == article.categoryId }))}
    }
}
