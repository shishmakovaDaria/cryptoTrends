//
//  SceneDelegate.swift
//  cryptoTrends
//
//  Created by Дарья Шишмакова on 26.01.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        let viewModel = TrendsViewModel()
        let trendsViewController = TrendsViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: trendsViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        window?.overrideUserInterfaceStyle = .dark
    }
}
