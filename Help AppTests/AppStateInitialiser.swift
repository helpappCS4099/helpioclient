//
//  AppStateInitialiser.swift
//  Help AppTests
//
//  Created by Artem Rakhmanov on 02/02/2023.
//

@testable import Help_App

protocol StateEnvironments {
    static func getBlank() -> AppState
    static func getNonVerifiedEmail() -> AppState
    static func getVerifiedWithoutPermissions() -> AppState
    static func getFullyAuthenticated() -> AppState
}

class AppStateInitialiser: StateEnvironments {
    static func getBlank() -> Help_App.AppState {
        <#code#>
    }
    
    static func getNonVerifiedEmail() -> Help_App.AppState {
        <#code#>
    }
    
    static func getVerifiedWithoutPermissions() -> Help_App.AppState {
        <#code#>
    }
    
    static func getFullyAuthenticated() -> Help_App.AppState {
        <#code#>
    }
}
