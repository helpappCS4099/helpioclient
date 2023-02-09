//
//  Interactors.swift
//  Help App
//
//  Created by Artem Rakhmanov on 09/02/2023.
//

import Foundation

struct Interactors {

    init(appState: AppState) {
        //default (production) constructor
        self.authenticationInteractor = AuthenticationInteractor(appState: appState)
    }
    
    let authenticationInteractor: AuthenticationInteractor
}

//"constructors" for dependency injection for production/testing, etc.
extension Interactors {
    static func bootstrap(appState: AppState) -> Interactors {
        return Interactors(appState: appState)
    }
}
