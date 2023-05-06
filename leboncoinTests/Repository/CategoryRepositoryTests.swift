//
//  CategoryRepositoryTests.swift
//  leboncoinTests
//
//  Created by Nicolas on 06/05/2023.
//

import XCTest
@testable import leboncoin

typealias CategoryEntity = leboncoin.Category
typealias CategoryDTO = leboncoin.CategoryDTO

class CategoryRepositoryTests: XCTestCase {
    
    private let entities = [CategoryEntity(id: 1, name: "Category 1"), CategoryEntity(id: 2, name: "Category 2")]
    private let dtos = [CategoryDTO(id: 1, name: "Category 1"), CategoryDTO(id: 2, name: "Category 2"), ]
    
    func testCategoryDTOtoDomain() {
        let categoryDTO = CategoryDTO(id: 1, name: "Category 1")
        let expectedEntity = CategoryEntity(id: 1, name: "Category 1")
        
        XCTAssertEqual(categoryDTO.toDomain(), expectedEntity)
    }
    
    func testJsonParsingFailed() async {
        let mockNetworkService = NetworkServiceImpl(decoder: FailJsonDecoder())
        let repository = CategoryRepositoryImpl(networkService: mockNetworkService)
        let result = await repository.getCategories()
        XCTAssertEqual(result, .failure(.jsonDecodingError))
    }

    func testGetCategoriesFromCache() async {
        // Arrange
        let expectedCategories = entities
        let cache = SimpleCache<CategoryEntity>()
        cache.addAll(expectedCategories)
        let repository = CategoryRepositoryImpl(networkService: MockNetworkService(result: .success([])), cache: cache)

        // Act
        let result = await repository.getCategories()

        // Assert
        XCTAssertFalse(cache.isEmpty) // cache should be not empty after retrieving items
        XCTAssertEqual(cache.items, expectedCategories)
        XCTAssertEqual(result, .success(expectedCategories))
    }

    func testGetCategoriesFromNetwork() async {
        // Arrange
        let expectedCategories = entities
        let networkService = MockNetworkService(result: .success(dtos))
        let cache = SimpleCache<CategoryEntity>()
        let repository = CategoryRepositoryImpl(networkService: networkService, cache: cache)

        // Act
        let result = await repository.getCategories()

        // Assert
        XCTAssertFalse(cache.isEmpty) // cache should contain items after retrieving from network
        XCTAssertEqual(cache.items, expectedCategories)
        XCTAssertEqual(result, .success(expectedCategories))
    }
    
    func testGetCategoriesFailures() async {
        let error = NSError(domain: "com.example.error", code: 0, userInfo: [NSLocalizedDescriptionKey: "message"])
        let errors: [NetworkError] = [.invalidRequest, .jsonDecodingError, .unknownError(error: error)]
        
        await errors.asyncForEach { error in
            let expectedResultFailure: Result<CategoryDTO, NetworkError> = .failure(error)
            let repository = CategoryRepositoryImpl(networkService: MockNetworkService<CategoryDTO>(result: expectedResultFailure), cache: SimpleCache<CategoryEntity>())

            // Act
            let result = await repository.getCategories()
            XCTAssertEqual(result, .failure(error))
        }
    }
}


extension Sequence {
    func asyncForEach(
        _ operation: (Element) async throws -> Void
    ) async rethrows {
        for element in self {
            try await operation(element)
        }
    }
}
