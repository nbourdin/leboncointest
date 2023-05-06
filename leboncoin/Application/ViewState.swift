//
//  ViewState.swift
//  leboncoin
//
//  Created by Nicolas on 07/05/2023.
//

import Foundation

enum ViewState<T: Equatable> {
    case data(T)
    case loading
    case failure(NetworkError)
    case idle
}

extension ViewState: Equatable {
    static func == (lhs: ViewState<T>, rhs: ViewState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.data(let a), .data(let b)):
            return a == b
        case (.loading, .loading):
            return true
        case (.failure(let errA), .failure(let errB)):
            return errA == errB
        case (.idle, .idle):
            return true
        default:
            return false
        }
    }
    
    
}
