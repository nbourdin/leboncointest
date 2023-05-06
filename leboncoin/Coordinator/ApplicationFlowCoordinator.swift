//
//  ApplicationFlowCoordinator.swift
//  leboncoin
//
//  Created by Nicolas on 04/05/2023.
//

import Foundation
import UIKit

protocol FlowCoordinator {
    func start()
}

final class ApplicationFlowCoordinator: FlowCoordinator {

    typealias DependencyProvider = ApplicationFlowCoordinatorDependencyProvider

    private let window: UIWindow
    private let dependencyProvider: DependencyProvider
    private var childCoordinators = [FlowCoordinator]()

    init(window: UIWindow, dependencyProvider: DependencyProvider) {
        self.window = window
        self.dependencyProvider = dependencyProvider
    }

    /// Creates all necessary dependencies and starts the flow
    func start() {
        let searchFlowCoordinator = ArticlesSearchFlowCoordinator(window: window, dependencyProvider: self.dependencyProvider)
        childCoordinators = [searchFlowCoordinator]
        searchFlowCoordinator.start()
    }

}
