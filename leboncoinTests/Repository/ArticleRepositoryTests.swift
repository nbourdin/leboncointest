//
//  ArticleRepositoryTests.swift
//  leboncoinTests
//
//  Created by Nicolas on 06/05/2023.
//

import XCTest
@testable import leboncoin

typealias ArticleEntity = leboncoin.Article
typealias ArticleDTO = leboncoin.ClassifiedAdDTO
typealias ImagesUrlsDTO = leboncoin.ClassifiedAdDTO.ImageUrlDTO
typealias ImagesUrlsEntity = leboncoin.Article.ImageUrl



class ArticleRepositoryTests: XCTestCase {
    
    func testJsonParsingFailed() async {
        let mockNetworkService = NetworkServiceImpl(decoder: FailJsonDecoder())
        let repository = ArticleRepositoryImpl(
            networkService: mockNetworkService,
            categoryRepository: MockCategoryRepository(
                result: .success(categoriesFakeDtos.map { $0.toDomain()})
            )
        )
        let result = await repository.getArticles(filter: nil)
        XCTAssertEqual(result, .failure(.jsonDecodingError))
    }
    
    func testGetArticlesWithNoFilter() async {

        // Given
        let categoryRepositoryMock = MockCategoryRepository(result: .success(categoriesFakeEntities))
        let mockNetworkService = MockNetworkService(result: .success(articlesFakeDtos))
        let repository = ArticleRepositoryImpl(
            networkService: mockNetworkService,
            categoryRepository: categoryRepositoryMock
        )

        // When
        let result = await repository.getArticles(filter: nil)
        // Then
        XCTAssertEqual(result, .success(articlesFakeEntities))
    }
    
    
    func testGetArticlesWithFilter() async {

        let categoryFilterId: Int64 = 1
        let expectedArticles = articlesFakeEntities.filter { $0.category?.id != nil && $0.category!.id == 1}
        // Given
        let categoryRepositoryMock = MockCategoryRepository(result: .success(categoriesFakeEntities))
        let mockNetworkService = MockNetworkService(result: .success(articlesFakeDtos))
        let repository = ArticleRepositoryImpl(
            networkService: mockNetworkService,
            categoryRepository: categoryRepositoryMock
        )

        // When
        let result = await repository.getArticles(filter: categoryFilterId)
        // Then
        XCTAssertEqual(result, .success(expectedArticles))
    }

    
    func testCategoryDTOtoDomain() {
        let category = CategoryEntity(id: 1, name: "Category 1")
        let date = Date.now
        let articleDto = ArticleDTO(id: 1, title: "Article 1", categoryId: 1, creationDate: date, description: "Description", isUrgent: true, imagesUrl: ImagesUrlsDTO(small: "1", thumb: "2"), price: 200, siret: "121211")
        let expectedEntity = ArticleEntity(id: 1, title: "Article 1", category: category, creationDate: date, description: "Description", isUrgent: true, imagesUrl: ImagesUrlsEntity(small: "1", thumb: "2"), price: 200, siret: "121211")
        
        XCTAssertEqual(articleDto.toDomain(category: category), expectedEntity)
    }
    
    func testGetCategoriesFailures() async {
        let error = NSError(domain: "com.example.error", code: 0, userInfo: [NSLocalizedDescriptionKey: "message"])
        let errors: [NetworkError] = [.invalidRequest, .jsonDecodingError, .unknownError(error: error)]
        
        await errors.asyncForEach { error in
            let expectedResultFailure: Result<ArticleDTO, NetworkError> = .failure(error)
            let repository = ArticleRepositoryImpl(
                networkService: MockNetworkService(result: expectedResultFailure),
                categoryRepository: MockCategoryRepository(
                    result: .success(categoriesFakeDtos.map { $0.toDomain()})
                )
            )

            // Act
            let result = await repository.getArticles(filter: nil)
            XCTAssertEqual(result, .failure(error))
        }
    }

}

