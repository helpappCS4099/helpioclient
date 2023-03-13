//
//  AuthenticationEndpoints.swift
//  Help App
//
//  Created by Artem Rakhmanov on 09/02/2023.
//

import Foundation

enum AccountCreationEndpoints {
    case checkEmail(_ email: String),
         createUser(
            email: String,
            password: String,
            firstName: String,
            lastName: String
         ),
         resendEmail,
         checkEmailVerification,
         updateAPNToken(_ token: String)
}

extension AccountCreationEndpoints: Endpoint {
    var requiresToken: Bool {
        switch self {
        case .checkEmail:
            return false
        case .createUser:
            return false
        case .resendEmail:
            return false
        case .checkEmailVerification:
            return false
        case .updateAPNToken:
            return false
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .checkEmail:
            return .get
        case .createUser:
            return .post
        case .resendEmail:
            return .post
        case .checkEmailVerification:
            return .get
        case .updateAPNToken:
            return .post
        }
    }
        
    var baseURLString: String {
        return BASEURLSTRING
    }
    
    var path: String {
        switch self {
        case .checkEmail(let email):
            return "users/email?email=\(String(email))"
        case .createUser:
            return "users"
        case .resendEmail:
            return "verification"
        case .checkEmailVerification:
            return "verification"
        case .updateAPNToken:
            return "apntoken"
        }
    }
    
    var headers: [String: Any]? {
        return ["Content-Type": "application/json",
                "Accept": "application/json"]
    }
    
    var body: [String : Any]? {
        switch self {
        case .checkEmail:
            return [:]
        case .createUser(email: let email, password: let password, firstName: let firstName, lastName: let lastName):
            return [
                "email": email,
                "password": password,
                "firstName": firstName,
                "lastName": lastName
            ]
        case .resendEmail:
            return [:]
        case .checkEmailVerification:
            return [:]
        case .updateAPNToken(let token):
            return [
                "deviceToken": token
            ]
        }
    }
}
