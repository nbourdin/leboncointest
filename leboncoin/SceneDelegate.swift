//
//  SceneDelegate.swift
//  leboncoin
//
//  Created by Nicolas on 03/05/2023.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: ApplicationFlowCoordinator!
    let dependencyProvider = ApplicationComponentsFactory()
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window


        self.appCoordinator = ApplicationFlowCoordinator(window: window, dependencyProvider: dependencyProvider)
        self.appCoordinator.start()
        
        window.makeKeyAndVisible()
    }


}
