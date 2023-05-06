//
//  CategoryListViewModel.swift
//  leboncoinTests
//
//  Created by Nicolas on 07/05/2023.
//

import XCTest
import Combine
@testable import leboncoin

class CategoryViewModelTests: XCTestCase {
    
    var viewModel: CategoryListViewModel!
    var mockRepository: MockCategoryRepository!
    var mockSharedViewModel: MockCategorySelectionViewModel!
    
    override func setUpWithError() throws {
        mockRepository = MockCategoryRepository()
        mockSharedViewModel = MockCategorySelectionViewModel()
        viewModel = CategoryListViewModel(repository: mockRepository, sharedViewModel: mockSharedViewModel)
    }

    func testInitialState() {
        XCTAssertEqual(viewModel.viewState, .idle)
        XCTAssertNil(viewModel.selectedCategory)
    }
    
    func testFetchCategorySuccess() {
        
        let categories = [CategoryEntity(id: 1, name: "Category 1"), CategoryEntity(id: 2, name: "Category 2")]
        let expectedCategories = [Category.all] + categories
        testFetchCategoryResult(
            mockResult: .success(categories),
            expectedResults: [.loading, .data(expectedCategories)]
        )
    }
    
    func testFetchCategoryFailure() {
        testFetchCategoryResult(
            mockResult: .failure(.jsonDecodingError),
            expectedResults: [.loading, .failure(.jsonDecodingError)]
        )
    }
    
    func testFetchCategoryResult(mockResult: Result<[CategoryEntity], NetworkError>, expectedResults: [CategoryViewState]) {
        var cancellables = Set<AnyCancellable>()
        mockRepository.result = mockResult
        
        let expectation = XCTestExpectation(description: "Emit in order [\(expectedResults.map { $0 })]")

        viewModel.$viewState.dropFirst().collect(2).sink(receiveValue: {
            XCTAssertEqual($0, expectedResults)
            expectation.fulfill()
        }).store(in: &cancellables)
        
        viewModel.fetch()
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testSelectedCategory() {
        let expectedFilterId: Int64 = 3
        viewModel.applyCategoryFilter(expectedFilterId)
        XCTAssertEqual(viewModel.sharedViewModel.selectedCategory, expectedFilterId)
    }
}
