//
//  ArticleListingViewModel.swift
//  leboncoin
//
//  Created by Nicolas on 01/05/2023.
//

import Foundation
import Combine
import UIKit.UIImage

typealias ArticleListViewState = ViewState<[Article]>
protocol ArticleListViewModelProtocol {
    func fetchArticlesWithFilters(filter categoryId: Int64?)
}
    
class ArticleListViewModel: ArticleListViewModelProtocol {
    
    private let navigator: ArticlesSearchNavigator
    private let repository: ArticleRepository
    
    init(
        navigator: ArticlesSearchNavigator,
        repository: ArticleRepository,
        sharedViewModel: CategorySelectionViewModel
    ) {
        self.navigator = navigator
        self.repository = repository
        sharedViewModel.delegate = self
    }
    
    @Published var viewState: ArticleListViewState = .idle
    
    internal func fetchArticlesWithFilters(filter categoryId: Int64? = nil) {
        Task {
            self.viewState = .loading
            let res = await repository.getArticles(filter: categoryId)
            switch res {
            case .success(let articles):
                self.viewState = .data(articles)
            case .failure(let error):
                self.viewState = .failure(error)
            }
            
        }
    }
    
    func fetch() {
        fetchArticlesWithFilters()
    }
    
    func showCategories() {
        navigator.showCategories()
    }
    
    func showArticleDetails(at index: Int) {
        if case let .data(articles) = viewState {
            navigator.showDetails(articles[index])
        }
        
    }
    
}


extension ArticleListViewModel: CategorySelectionDelegate {
    func onCategoryFilterChanged(_ filter: Int64?) {
        print(filter)
        fetchArticlesWithFilters(filter: filter)
    }
}
