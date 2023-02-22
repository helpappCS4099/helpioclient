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
    
    //extract to NavigationState? or this is extra?
    @Published var currentPage: AppTab = .home
    
    @Published var auth: AuthState = AuthState()
    
    init() {}
    
    init(auth: AuthState) {
        self.auth = auth
    }
    
    #if DEBUG
    //convenience for dev, launch logged in at page
    init(currentPage: AppTab) {
        self.userIsLoggedIn = true
        self.currentPage = currentPage
    }
    #endif
}

//"constructors" for dependency injection for production/testing, etc.
extension AppState {
    static func bootstrap() -> AppState {
        return AppState()
    }
    
    #if DEBUG
    static func developmentLoggedIn(currentPage: AppTab = .home) -> AppState {
        //with correct params, etc
        return AppState(currentPage: currentPage)
    }
    
    static func bootstrapWithAuthAt(screen: AuthScreen) -> AppState {
        return AppState(auth: AuthState.initAtScreen(screen: screen))
    }
    #endif
}
