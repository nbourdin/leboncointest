//
//  CategorySelectionViewModel.swift
//  leboncoin
//
//  Created by Nicolas on 04/05/2023.
//

import Foundation

protocol CategorySelectionDelegate {
    func onCategoryFilterChanged(_ filter: Int64?)
}


// Viewmodel used for share selected category filter trough viewmodels
class CategorySelectionViewModel: CategorySelection {
     
    private(set) var selectedCategory: Int64? {
        didSet {
            delegate?.onCategoryFilterChanged(selectedCategory)
        }
    }
    
    var delegate: CategorySelectionDelegate?
    
    func applyCategoryFilter(_ filter: Int64?) {
        selectedCategory = filter
    }
    
}
