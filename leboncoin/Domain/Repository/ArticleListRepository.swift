//
//  ArticleListRepository.swift
//  leboncoin
//
//  Created by Nicolas on 04/05/2023.
//

import Foundation

protocol ArticleRepository: AnyObject {
    func getArticles(filter categoryId: Int64?) async -> Result<[Article], NetworkError>
}


class ArticleRepositoryImpl: ArticleRepository {
    
    private let networkService: NetworkService
    private let categoryRepository: CategoryRepository
    private let cache: any Cache<Article>
    init(
        networkService: NetworkService,
        categoryRepository: CategoryRepository,
        cache: any Cache<Article> = SimpleCache<Article>()
    ) {
        self.networkService = networkService
        self.categoryRepository = categoryRepository
        self.cache = cache
    }
    
    func getArticles(filter categoryId: Int64?) async -> Result<[Article], NetworkError> {
        // get result from remote or cache
        let items: Result<[Article], NetworkError> = await {
            if (!cache.isEmpty) {
                return .success(cache.items)
            }
            
            guard case let .success(categories) = await categoryRepository.getCategories() else {
                return .failure(.invalidResponse)
            }
            let result = await networkService.load(Resource<[ClassifiedAdDTO]>(url: ApiConstants.articlesURL))
            return result.map { dtos in
                let entities = dtos.map { dto in
                    let category = categories.first(where: {$0.id == dto.categoryId })
                    return dto.toDomain(category: category)
                }
                cache.addAll(entities)
                return entities
            }
        }()
        
        // filter result
        return items.map { articles in
            if let id = categoryId {
                return articles.filter { $0.category?.id == id }
            }
            return articles
        }
        
    }
    

}
