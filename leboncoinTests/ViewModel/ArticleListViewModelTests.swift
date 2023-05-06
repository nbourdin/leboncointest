//
//  ArticleListViewModelTests.swift
//  leboncoinTests
//
//  Created by Nicolas on 07/05/2023.
//

import XCTest
import Combine
@testable import leboncoin

final class ArticleListViewModelTests: XCTestCase {

    var articleListViewModel: ArticleListViewModel!
    var mockArticleRepository: MockArticleRepository!
    override func setUp() {
        mockArticleRepository = MockArticleRepository(result: .success([]))
        articleListViewModel = ArticleListViewModel(
            navigator: MockArticleSearchNavigator(),
            repository: mockArticleRepository,
            sharedViewModel: MockCategorySelectionViewModel()
        )
    }
    func testInitialState() {
        XCTAssertEqual(articleListViewModel.viewState, .idle)
    }
    
    func testFetchCategorySuccessWithNoFilters() {
        testFetchArticleResult(
            mockResult: .success(articlesFakeEntities),
            expectedResults: [.loading, .data(articlesFakeEntities)],
            category: nil
        )
    }
    
    func testFetchCategorySuccessWithFilters() {
        let categoryId: Int64 = 3
        let filteredResult = articlesFakeEntities.filter { $0.category?.id == categoryId }
        testFetchArticleResult(
            mockResult: .success(filteredResult),
            expectedResults: [.loading, .data(filteredResult)],
            category: categoryId
        )
    }
    
    func testFetchCategoryFailure() {
        testFetchArticleResult(
            mockResult: .failure(.jsonDecodingError),
            expectedResults: [.loading, .failure(.jsonDecodingError)],
            category: nil
        )
    }
    
    
    func testFetchArticleResult(mockResult: Result<[ArticleEntity], NetworkError>, expectedResults: [ArticleListViewState], category: Int64?) {
        var cancellables = Set<AnyCancellable>()
        mockArticleRepository.result = mockResult
        
        let expectation = XCTestExpectation(description: "Emit in order [\(expectedResults.map { $0 })]")

        articleListViewModel.$viewState.dropFirst().collect(2).sink(receiveValue: {
            XCTAssertEqual($0, expectedResults)
            expectation.fulfill()
        }).store(in: &cancellables)
        
        articleListViewModel.fetchArticlesWithFilters(filter: category)
        
        wait(for: [expectation], timeout: 1)
    }
    
}

