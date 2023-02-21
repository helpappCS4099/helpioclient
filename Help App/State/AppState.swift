//
//  AppState.swift
//  Help App
//
//  Created by Artem Rakhmanov on 02/02/2023.
//

import SwiftUI

class AppState: ObservableObject {
    
    @Published var userIsLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isLogged") {
        didSet {
            UserDefaults.standard.set(self.userIsLoggedIn, forKey: "isLogged")
        }
    }
    
    @Published var auth: AuthState = AuthState()
    
    init() {}
    
    init(auth: AuthState) {
        self.auth = auth
    }
}

//"constructors" for dependency injection for production/testing, etc.
extension AppState {
    static func bootstrap() -> AppState {
        return AppState()
    }
    
    #if DEBUG
    static func developmentLoggedIn() -> AppState {
        //with correct params, etc
        return AppState()
    }
    
    static func bootstrapWithAuthAt(screen: AuthScreen) -> AppState {
        return AppState(auth: AuthState.initAtScreen(screen: screen))
    }
    #endif
}
