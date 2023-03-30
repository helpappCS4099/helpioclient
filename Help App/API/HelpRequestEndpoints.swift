//
//  HelpRequestEndpoints.swift
//  Help App
//
//  Created by Artem Rakhmanov on 16/03/2023.
//

import Foundation

enum HelpRequestEndpoint {
    case availableFriends
    case newHelpRequest(category: Int, messages: [String], respondents: [RespondentModel])
    case sos(helpRequestID: String)
    case location(helpRequestID: String, userID: String, latitude: Double, longitude: Double)
}

extension HelpRequestEndpoint: Endpoint {
    var httpMethod: HTTPMethod {
        switch self {
        case .availableFriends:
            return .get
        case .newHelpRequest( _, _, _):
            return .post
        case .sos(_):
            return .get
        case .location(_,_,_,_):
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
        case .sos(let helpRequestID):
            return "helprequests/\(helpRequestID)/sos"
        case .location(let hid, let uid,_,_):
            return "helprequests/\(hid)/\(uid)/location"
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
                "respondents" : respondents.map({ res in
                    return res.convertToDictionary()
                })
            ]
        case .sos(_):
            return [:]
        case .location(_,_,let lat,let lgt):
            return [
                "latitude": lat,
                "longitude": lgt
            ]
        }
    }
}
