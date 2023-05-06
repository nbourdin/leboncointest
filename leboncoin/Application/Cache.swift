//
//  Cache.swift
//  leboncoin
//
//  Created by Nicolas on 06/05/2023.
//

import Foundation


protocol Cache<T> {
    associatedtype T
    func addAll(_ items: [T])
    var isEmpty: Bool { get }
    var items: [T] { get }
}


final class SimpleCache<T>: Cache {
    
    private var cache: [T] = []

    var isEmpty: Bool {
        return cache.isEmpty
    }
    
    var items: [T] {
        return self.cache
    }
    
    func addAll(_ items: [T]) {
        self.cache = items
    }
}
