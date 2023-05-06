//
//  CategoryViewModel.swift
//  leboncoin
//
//  Created by Nicolas on 04/05/2023.
//

import Foundation
import Combine

typealias CategoryViewState = ViewState<[Category]>

protocol CategorySelection {
    func applyCategoryFilter(_ filter: Int64?)
    var selectedCategory: Int64? { get }
}

class CategoryListViewModel: CategorySelection {
    
    let repository: CategoryRepository
    let sharedViewModel: CategorySelectionViewModel
    
    @Published var viewState: CategoryViewState
    
    private var currentFilter: Int64?
    
    init(repository: CategoryRepository, sharedViewModel: CategorySelectionViewModel) {
        self.repository = repository
        self.sharedViewModel = sharedViewModel
        self.currentFilter = sharedViewModel.selectedCategory
        self.viewState = .idle
    }
    
    var selectedCategory: Int64? { return sharedViewModel.selectedCategory }
    
    internal func applyCategoryFilter(_ filter: Int64?) {
        sharedViewModel.applyCategoryFilter(filter)
    }
    
    func applyCurrentFilter () {
        sharedViewModel.applyCategoryFilter(currentFilter)
    }
    
    func fetch(){
        Task {
            viewState = .loading
            let res = await repository.getCategories()
            switch res {
            case .failure(let error):
                viewState = .failure(error)
            case .success(let items):
                viewState = .data([Category.all] + items)
            }
        }
    }
    
    func selectCategory(at index: Int) {
        if case let .data(categories) = viewState {
            let newFilter = categories[index]
            applyCategoryFilter(newFilter.id)
        }
    }
}
