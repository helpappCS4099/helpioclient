//
//  AuthenticationInteractor.swift
//  Help App
//
//  Created by Artem Rakhmanov on 02/02/2023.
//

import Foundation

protocol SessionOperations {
    
    func logIn(email: String,
               password: String)
        async throws -> OperationStatus
    
    func logOut()
        async throws -> OperationStatus
}

protocol NewUserCreation {
    
    func createNewUser(email: String,
                       password: String,
                       firstName: String,
                       lastName: String)
        async throws -> OperationStatus
    
    func checkEmail(email: String)
        async throws -> OperationStatus
}


