//
//  Enums.swift
//  Help App
//
//  Created by Artem Rakhmanov on 02/02/2023.
//

import Foundation

enum OperationStatus: Comparable {
    case success
    case failure(errorMessage: String)
    
    var errorMessage: String {
        get {
            switch self {
            case .success:
                return ""
            case .failure(let errorMessage):
                return errorMessage
            }
        }
    }
    
    
}

enum AppTab {
    case home, friends, account
    //help request??
}

enum AuthScreen {
    case landing, login, signup_credentials, signup_name, verification, persmissions
    
    var headerTitle: String {
        switch self {
        case .landing:
            return "Help App"
        case .login:
            return "Sign In"
        case .signup_credentials:
            return "Create Your Account"
        case .signup_name:
            return "Create Your Account"
        case .verification:
            return "Verify Your Email"
        case .persmissions:
            return "Grant Permissions"
        }
    }
    
    var headerSubtitle: String {
        switch self {
        case .verification:
            return "Verify Your Email"
        default:
            return ""
        }
    }
    
    var primaryButtonLabel: String {
        switch self {
        case .landing:
            return "Sign In"
        case .login:
            return "Continue"
        case .signup_credentials:
            return "Continue"
        case .signup_name:
            return "Create Account"
        case .verification:
            return "Refresh"
        case .persmissions:
            return "Continue"
        }
    }
    
    var secondaryButtonLabel: String {
        switch self {
        case .landing:
            return "Create Account"
        case .login:
            return "Create Account"
        case .signup_credentials:
            return "or Sign In"
        case .signup_name:
            return "Back"
        case .verification:
            return "Back"
        case .persmissions:
            return "Back"
        }
    }
}
