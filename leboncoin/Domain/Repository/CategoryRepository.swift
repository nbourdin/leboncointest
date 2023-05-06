//
//  CategoryRepository.swift
//  leboncoin
//
//  Created by Nicolas on 04/05/2023.
//

import Foundation

protocol CategoryRepository: AnyObject {
    func getCategories() async -> Result<[Category], NetworkError>
}

final class CategoryRepositoryImpl: CategoryRepository {
    private let networkService: NetworkService
    private let cache: any Cache<Category>
    init(networkService: NetworkService, cache: any Cache<Category> = SimpleCache<Category>()) {
        self.cache = cache
        self.networkService = networkService
    }
    
    func getCategories() async -> Result<[Category], NetworkError> {
        if (!cache.isEmpty) {
            debugPrint("Get categories from cache")
            return .success(cache.items)
        }
            
        let result = await networkService.load(Resource<[CategoryDTO]>(url: ApiConstants.categoriesURL))
        return result.map { dtos in
            let entities = dtos.map { $0.toDomain() }
            cache.addAll(entities)
            return entities
        }
    }
}
