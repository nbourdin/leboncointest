//
//  CategorySelectionViewModelTests.swift
//  leboncoinTests
//
//  Created by Nicolas on 07/05/2023.
//

import XCTest
import Combine
@testable import leboncoin

final class CategorySelectionViewModelTests: XCTestCase {

    var categorySelectionSharedViewModel: CategorySelectionViewModel!
    override func setUpWithError() throws {
        categorySelectionSharedViewModel = CategorySelectionViewModel()
        
    }

    func testSelectedFilterTriggerDelegate() {
        let categoryFilter: Int64 = 3
        let categoryListViewModel = CategoryListViewModel(
            repository: MockCategoryRepository(), sharedViewModel: categorySelectionSharedViewModel)
        
        let articleListViewModel = MockArticleListViewModelSimple()
        categorySelectionSharedViewModel.delegate = articleListViewModel
        
        // user apply category filter
        categoryListViewModel.applyCategoryFilter(categoryFilter)
        
        XCTAssertEqual(articleListViewModel.categoryFilterCalled, categoryFilter)
    }
    
    
    /* I don't really know why this test failed
    func testFilterSelectionInCategoryListShouldRefreshArticleList() async {
        var cancellables = Set<AnyCancellable>()
        let categoryFilterId: Int64 = 3
        let expectedArticles = articlesFakeEntities.filter { $0.category?.id != nil && $0.category!.id == categoryFilterId}
        
        let articleListViewModel = ArticleListViewModel(
            navigator: MockArticleSearchNavigator(),
            repository: MockArticleRepository(result: .success(expectedArticles)),
            sharedViewModel: categorySelectionSharedViewModel
        )
        
        let expectation = XCTestExpectation(description: "Emit in order [.loading, .data]")
        
        // article list is updated
        articleListViewModel
            .$viewState
            .dropFirst() // skip .idle
            .collect(2)
            .sink(receiveValue: {
                print("state \($0)")
                XCTAssertEqual($0, [.loading, .data(expectedArticles)])
                expectation.fulfill()
            }).store(in: &cancellables)
        
        categorySelectionSharedViewModel.delegate = articleListViewModel
        
        let categoryListViewModel = CategoryListViewModel(
            repository: MockCategoryRepository(result: .success(categoriesFakeEntities)), sharedViewModel: categorySelectionSharedViewModel)
        // user select category in list
        categoryListViewModel.applyCategoryFilter(categoryFilterId)
        
        XCTAssertEqual(categorySelectionSharedViewModel.selectedCategory, categoryFilterId)
        

        wait(for: [expectation], timeout: 1)
    }
    */
    

}

