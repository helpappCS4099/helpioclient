//
//  SceneDelegate.swift
//  Help App
//
//  Created by Artem Rakhmanov on 09/02/2023.
//

import SwiftUI
import TouchVisualizer

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        //for user study, enable touch visualisation
        Visualizer.start()
        
        //perform app dependency injections
        let environement = Environment.bootstrap()
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.environment = environement
        }
        //launch root scene
        let rootView = RootView(dependencies: environement.diContainer)
                            .environmentObject(environement.diContainer.appState)
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: rootView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
      
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
      
    }

    func sceneWillResignActive(_ scene: UIScene) {
      
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
      
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
      
    }
}
