//
//  Help_AppApp.swift
//  Help App
//
//  Created by Artem Rakhmanov on 31/01/2023.
//
import UIKit
import CoreLocation

//@main
//struct Help_AppApp: App {
//
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
////    @StateObject var appState: AppState = AppState()
//}

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var environment: Environment?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfig: UISceneConfiguration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("devie token:", deviceToken)
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        if let environment = environment {
            let sessionInteractor = environment.diContainer.interactors.sessionInteractor
            Task {
                //push token to server
                let response = await sessionInteractor.updateAPNToken(deviceToken: tokenString)
                if response == .success {
                    //log in
                    UserDefaults.standard.set(true, forKey: "isLogged")
                    environment.diContainer.appState.userIsLoggedIn = true
                } else {
                    print("coult not update device token", response)
                }
                
                //success: allow to app by changing logged in:)
            }
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("failed for push notif:", error.localizedDescription)
    }
    
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//
//        switch manager.authorizationStatus {
//            case .notDetermined:
//                print("not determined authstatus for location")
//                if (!alreadyRequestedLocationWhenInUse) {
//                    print("Requesting location access 'while in use'.")
//                    manager.requestWhenInUseAuthorization();
//                    UserDefaults.standard.set(true, forKey: "alreadyRequestedLocationWhenInUse")
//                    alreadyRequestedLocationWhenInUse = true
//                } else {
////                    promptToChangeLocationSettings()
//                    //ACT ON IT
//                }
//                break
//            case .restricted, .denied:
//                print("No Location access")
//                //dont allow app usage until fixed
//                break
//            case .authorizedWhenInUse:
//                print("authstatus location when in use...")
//                if (!alreadyRequestedLocationAlways) {
//                    print("Requesting location access 'Always'.")
//                    UserDefaults.standard.set(true, forKey: "alreadyRequestedLocationAlways")
//                    alreadyRequestedLocationAlways = true
//                    DispatchQueue.main.async {
//                        UserDefaults.standard.set(true, forKey: "alreadyRequestedLocationAlways")
//                        alreadyRequestedLocationAlways = true
//                    }
//                } else {
//                    print("hey")
////                    promptToChangeLocationSettings()
//                }
//                break
//            case .authorizedAlways:
//                //all good
//                print("granted authorization to always get location")
//                break
//            default:
//                return
//            }
//        }
}

////https://stackoverflow.com/questions/63531310/how-to-force-always-location-access-in-ios-app
//var alreadyRequestedLocationWhenInUse = UserDefaults.standard.bool(forKey: "alreadyRequestedLocationWhenInUse")
//var alreadyRequestedLocationAlways = UserDefaults.standard.bool(forKey: "alreadyRequestedLocationAlways")

let clManager = CLLocationManager.init()
