//
//  SceneDelegate.swift
//  Walmart Chile
//
//  Created by Samuel García on 19-04-24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let cart = Cart()
        
        window = UIWindow(windowScene: windowScene)
        let homePresenter = HomePresenter(cart: cart)
        window?.rootViewController = homePresenter.viewController
        window?.makeKeyAndVisible()
    }
}

