//
//  APIErrors.swift
//  Help App
//
//  Created by Artem Rakhmanov on 16/02/2023.
//

import Foundation

protocol APIRequestError {
    var status: Int {get}
    var errorMessage: String {get}
}

extension String: Error {}

enum APIError: Error, APIRequestError {
    
    case notAuthorized(status: Int, errorMessage: String),
         serverError(status: Int, errorMessage: String),
         badRequest(status: Int, errorMessage: String),
         unknown(status: Int, errorMessage: String)
    
    var status: Int {
        switch self {
        case .notAuthorized(let status, _):
            return status
        case .serverError(let status, _):
            return status
        case .badRequest(let status, _):
            return status
        case .unknown(let status, _):
            return status
        }
    }
    
    var errorMessage: String {
        switch self {
        case .notAuthorized(_, let errorMessage):
            return errorMessage
        case .serverError(_, let errorMessage):
            return errorMessage
        case .badRequest(_, let errorMessage):
            return errorMessage
        case .unknown(_, let errorMessage):
            return errorMessage
        }
    }
}
