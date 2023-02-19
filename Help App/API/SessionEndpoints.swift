//
//  SessionEndpoints.swift
//  Help App
//
//  Created by Artem Rakhmanov on 09/02/2023.
//

import Foundation

enum SessionEndpoints {
    
    case login(_ email: String, _ password: String)
    case logout
    
}

extension SessionEndpoints: Endpoint {
    var requiresToken: Bool {
        switch self {
        case .login:
            return false
        case .logout:
            return true
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .login:
            return HTTPMethod.post
        case .logout:
            return HTTPMethod.get
        }
        
    }
    
    var baseURLString: String {
        return BASEURLSTRING
    }
    
    var path: String {
        switch self {
        case .login:
            return "login"
        case .logout:
            return "logout"
        }
    }
    
    var headers: [String: Any]? {
        return ["Content-Type": "application/json",
                "Accept": "application/json"]
    }
    
    var body: [String : Any]? {
        switch self {
        case .login(let email, let password):
            return [
                "email": email,
                "password": password
            ]
        case .logout:
            return [:]
        }
    }
}
