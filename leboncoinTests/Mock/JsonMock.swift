//
//  JsonMock.swift
//  leboncoinTests
//
//  Created by Nicolas on 06/05/2023.
//

import Foundation
import XCTest
@testable import leboncoin

extension XCTestCase {
    
    func articlesStubs() -> [ArticleDTO] {
        let data = try! Data(contentsOf: Bundle(for: type(of: self)).url(forResource: "Articles", withExtension: "json")!)
        
        let decoder = AppJSONDecoderImpl()
        
        return try! decoder.decode([ArticleDTO].self, from: data)
    }
    
    func categoryStubs() -> [CategoryDTO] {
        let data = try! Data(contentsOf: Bundle(for: type(of: self)).url(forResource: "Categories", withExtension: "json")!)
        
        let decoder = AppJSONDecoderImpl()
        
        return try! decoder.decode([CategoryDTO].self, from: data)
    }
}
