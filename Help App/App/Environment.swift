//
//  Environment.swift
//  Help App
//
//  Created by Artem Rakhmanov on 16/02/2023.
//

import Foundation

class Environment {
    
    let diContainer: DI
    
    init(diContainer: DI) {
        self.diContainer = diContainer
    }

    
    static func bootstrap() -> Environment{
        //urlsession
        
        let appState = AppState()
        let repositories = Repositories.bootstrap()
        let interactors = Interactors.bootstrap(appState: appState, repositories: repositories)
            
        let diContainer = DI(appState: appState, interactors: interactors)
        
        return Environment(diContainer: diContainer)
    }
    
    #if DEBUG
    static func bootstrapLoggedIn(currentPage: AppTab = .home) -> Environment{
        let appState = AppState.developmentLoggedIn(currentPage: currentPage)
        let repositories = Repositories.bootstrap()
        let interactors = Interactors.bootstrap(appState: appState, repositories: repositories)
            
        let diContainer = DI(appState: appState, interactors: interactors)
        
        return Environment(diContainer: diContainer)
    }
    #endif
}
