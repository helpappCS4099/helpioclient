//
//  Help_AppApp.swift
//  Help App
//
//  Created by Artem Rakhmanov on 31/01/2023.
//
import UIKit

//@main
//struct Help_AppApp: App {
//
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
////    @StateObject var appState: AppState = AppState()
//}

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfig: UISceneConfiguration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
}
