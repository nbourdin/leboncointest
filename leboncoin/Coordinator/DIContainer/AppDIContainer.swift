//
//  AppDIContainer.swift
//  leboncoin
//
//  Created by Nicolas on 04/05/2023.
//

import Foundation
import UIKit

final class ApplicationComponentsFactory {
 
    lazy var networkService: NetworkService = {
        return NetworkServiceImpl()
    }()
    
    lazy var categoryRepository: CategoryRepository = {
        return CategoryRepositoryImpl(networkService: networkService)
    }()
    
    lazy var articleRepository: ArticleRepository = {
        return ArticleRepositoryImpl(networkService: networkService, categoryRepository: categoryRepository)
    }()
    
    lazy var imageLoaderService: ImageLoader = {
        return ImageLoaderServiceImpl()
    }()
    
    lazy var sharedViewModel = CategorySelectionViewModel()
}

protocol ApplicationFlowCoordinatorDependencyProvider: ArticlesSearchFlowCoordinatorDependencyProvider {}

protocol ArticlesSearchFlowCoordinatorDependencyProvider: AnyObject {
    func articlesSearchNavigationController(navigator: ArticlesSearchNavigator) -> UINavigationController
    func articleDetailsController(_ article: Article) -> UIViewController
    
    func categoriesController() -> UIViewController
}


extension ApplicationComponentsFactory: ApplicationFlowCoordinatorDependencyProvider {
    func articlesSearchNavigationController(navigator: ArticlesSearchNavigator) -> UINavigationController {
        let viewModel = ArticleListViewModel(navigator: navigator, repository: articleRepository, sharedViewModel: sharedViewModel)
        let articleListController = ArticleListViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: articleListController)
        return navigationController
    }
    
    func articleDetailsController(_ article: Article) -> UIViewController {
        let viewModel = ArticleDetailsViewModel(article: article, imageLoaderService: imageLoaderService)
        return ArticleDetailsViewController(viewModel: viewModel)
    }
    
    func categoriesController() -> UIViewController {
        let viewModel = CategoryListViewModel(repository: categoryRepository, sharedViewModel: sharedViewModel)
        return CategoryViewController(viewModel: viewModel)
    }
    
}

protocol ArticlesSearchNavigator: AnyObject {
    func showDetails(_ article: Article)
    func showCategories()
}


class ArticlesSearchFlowCoordinator: FlowCoordinator {
    fileprivate let window: UIWindow
    fileprivate var searchNavigationController: UINavigationController?
    fileprivate let dependencyProvider: ArticlesSearchFlowCoordinatorDependencyProvider

    init(window: UIWindow, dependencyProvider: ArticlesSearchFlowCoordinatorDependencyProvider) {
        self.window = window
        self.dependencyProvider = dependencyProvider
    }

    func start() {
        let searchNavigationController = dependencyProvider.articlesSearchNavigationController(navigator: self)
        window.rootViewController = searchNavigationController
        self.searchNavigationController = searchNavigationController
    }
}

extension ArticlesSearchFlowCoordinator: ArticlesSearchNavigator {
    func showDetails(_ article: Article) {
        let controller = self.dependencyProvider.articleDetailsController(article)
        searchNavigationController?.pushViewController(controller, animated: true)
    }
    
    func showCategories() {
        let controller = self.dependencyProvider.categoriesController()
        self.searchNavigationController?.present(controller, animated: true)
    }
    

}
