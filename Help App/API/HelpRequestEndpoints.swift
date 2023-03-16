//
//  HelpRequestEndpoints.swift
//  Help App
//
//  Created by Artem Rakhmanov on 16/03/2023.
//

import Foundation

enum HelpRequestEndpoint {
    case availableFriends
    case newHelpRequest(category: Int, messages: NewMessageModel, respondents: [RespondentModel])
}

extension HelpRequestEndpoint: Endpoint {
    var httpMethod: HTTPMethod {
        switch self {
        case .availableFriends:
            return .get
        case .newHelpRequest( _, _, _):
            return .post
        }
    }
    
    var baseURLString: String {
        return BASEURLSTRING
    }
    
    var path: String {
        switch self {
        case .availableFriends:
            return "helprequests/availableFriends"
        case .newHelpRequest( _, _, _):
            return "helprequests"
        }
    }
    
    var headers: [String : Any]? {
        ["Content-Type": "application/json",
                "Accept": "application/json"]
    }
    
    var requiresToken: Bool {
        return true
    }
    
    var body: [String : Any]? {
        switch self {
        case .availableFriends:
            return [:]
        case .newHelpRequest(let category, let messages, let respondents):
            return [
                "category" : category,
                "messages" : messages,
                "respondents" : respondents
            ]
        }
    }
}
