//
//  SceneDelegate.swift
//  WordsGame
//
//  Created by ashubin on 04.09.20.
//  Copyright © 2020 Alex Shubin. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let contentView = TabBarView(store: AppStore(initialState: AppState(),
                                                     reducer: reducer,
                                                     environment: .live))

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}

