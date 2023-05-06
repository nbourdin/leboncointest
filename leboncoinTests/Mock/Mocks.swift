//
//  Mocks.swift
//  leboncoinTests
//
//  Created by Nicolas on 07/05/2023.
//

import Foundation
@testable import leboncoin

class MockArticleSearchNavigator: ArticlesSearchNavigator {
    
    func showDetails(_ article: leboncoin.Article) {
        
    }
    
    func showCategories() {
        
    }
    
    
}

class MockArticleListViewModelSimple: ArticleListViewModelProtocol, CategorySelectionDelegate {
    private(set) var categoryFilterCalled: Int64?
    
    func onCategoryFilterChanged(_ filter: Int64?) {
        categoryFilterCalled = filter
    }
    
    func fetchArticlesWithFilters(filter categoryId: Int64?) {
        
    }
}


class MockArticleListCompleteViewModel: ArticleListViewModel {
    
}

class MockCategoryListViewModel: CategoryListViewModel {
}


class MockNetworkService<T>: NetworkService {
    private let result: Result<T, NetworkError>
    init(result: Result<T, NetworkError>) {
        self.result = result
    }

    func load<T>(_ resource: Resource<T>) async -> Result<T, NetworkError> where T : Decodable {
        return result.map { $0 as! T }
    }
}

class FailJsonDecoder: AppJSONDecoder {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        throw NSError(domain: "com.leboncoin.blabla", code: -1)
    }
    
    
}


class MockCategoryRepository: CategoryRepository {
    var result: Result<[CategoryEntity], NetworkError>?
    init(result: Result<[CategoryEntity], NetworkError>? = nil) {
        self.result = result
    }
    
    func getCategories() async -> Result<[CategoryEntity], NetworkError> {
        guard let result = result else {
            fatalError("MockCategoryRepository.getCategories() has no result set.")
        }
       return result
    }
}


class MockCategorySelectionViewModel: CategorySelectionViewModel {
}

class MockArticleRepository: ArticleRepository {
    var result: Result<[ArticleEntity], NetworkError>
    init(result: Result<[ArticleEntity], NetworkError>) {
        self.result = result
    }
    func getArticles(filter categoryId: Int64?) async -> Result<[leboncoin.Article], leboncoin.NetworkError> {
        return result
    }
    
    
}
