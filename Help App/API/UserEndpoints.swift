//
//  UserEndpoints.swift
//  Help App
//
//  Created by Artem Rakhmanov on 08/03/2023.
//

import Foundation

enum UserEndpoints {
    case me
    case user(userID: String)
    case search(searchString: String)
    case addFriend(myUserID: String, friendUserID: String)
    case deleteFriend(myUserID: String, friendUserID: String)
}

extension UserEndpoints: Endpoint {
    var httpMethod: HTTPMethod {
        switch self {
        case .me:
            return HTTPMethod.get
        case .user(userID: _):
            return HTTPMethod.get
        case .search(searchString: _):
            return HTTPMethod.get
        case .addFriend(myUserID: _, friendUserID: _):
            return HTTPMethod.post
        case .deleteFriend(myUserID: _, friendUserID: _):
            return HTTPMethod.delete
        }
    }
    
    var baseURLString: String {
        return BASEURLSTRING
    }
    
    var path: String {
        switch self {
        case .me:
            return "users/me"
        case .user(userID: let userID):
            return "users/\(userID)"
        case .search(searchString: let searchString):
            return "users?search=\(searchString)"
        case .addFriend(myUserID: let myUserID, friendUserID: let friendUserID):
            return "users/\(myUserID)/friends/\(friendUserID)"
        case .deleteFriend(myUserID: let myUserID, friendUserID: let friendUserID):
            return "users/\(myUserID)/friends/\(friendUserID)"
        }
    }
    
    var headers: [String : Any]? {
        return ["Content-Type": "application/json",
                "Accept": "application/json"]
    }
    
    var requiresToken: Bool {
        return true
    }
    
    var body: [String : Any]? {
        switch self {
        case .me:
            return [:]
        case .user(userID: _):
            return [:]
        case .search(searchString: _):
            return [:]
        case .addFriend(myUserID: _, friendUserID: _):
            return [:]
        case .deleteFriend(myUserID: _, friendUserID: _):
            return [:]
        }
    }
    
    
}
