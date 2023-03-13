//
//  Interactors.swift
//  Help App
//
//  Created by Artem Rakhmanov on 09/02/2023.
//

import Foundation

class Interactors {

    init(appState: AppState, repositories: Repositories) {
        //default (production) constructor
        self.session = SessionInteractor(appState: appState, sessionWebRepository: repositories.session)
        self.user = UserInteractor(appState: appState, userWebRepository: repositories.user)
    }
    
    let session: SessionInteractor
    let user: UserInteractor
}

//"constructors" for dependency injection for production/testing, etc.
extension Interactors {
    static func bootstrap(appState: AppState, repositories: Repositories) -> Interactors {
        return Interactors(appState: appState, repositories: repositories)
    }
}
