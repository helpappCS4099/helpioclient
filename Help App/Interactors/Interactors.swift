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
        self.sessionInteractor = SessionInteractor(appState: appState, sessionWebRepository: repositories.session)
    }
    
    let sessionInteractor: SessionInteractor
}

//"constructors" for dependency injection for production/testing, etc.
extension Interactors {
    static func bootstrap(appState: AppState, repositories: Repositories) -> Interactors {
        return Interactors(appState: appState, repositories: repositories)
    }
}
