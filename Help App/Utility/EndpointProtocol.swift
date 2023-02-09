//
//  EndpointProtocol.swift
//  Help App
//
//  Created by Artem Rakhmanov on 09/02/2023.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case connect = "CONNECT"
    case options = "OPTIONS"
    case trace = "TRACE"
    case patch = "PATCH"
}

protocol Endpoint {
    var httpMethod: HTTPMethod { get }
    var baseURLString: String { get }
    var path: String { get }
    var headers: [String: Any]? { get }
    var requiresToken: Bool {get}
    var body: [String: Any]? { get }
}

extension Endpoint {
    // a default extension that creates the full URL
    var url: String {
        return baseURLString + path
    }
}
