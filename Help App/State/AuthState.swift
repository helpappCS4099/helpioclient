//
//  AuthState.swift
//  Help App
//
//  Created by Artem Rakhmanov on 16/02/2023.
//

import Foundation

class AuthState: ObservableObject {
    
    @Published var currentScreen: AuthScreen = .landing
    
}
