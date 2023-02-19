//
//  URLRequest.swift
//  Help App
//
//  Created by Artem Rakhmanov on 16/02/2023.
//

import Foundation

extension URLRequest {
    
    //custom constructor to generate a URLRequest object from the Enpoint enum
    init?(endpoint: Endpoint) {
        self.init(url: URL(string: endpoint.url)!)
        self.httpMethod = endpoint.httpMethod.rawValue
        if (endpoint.httpMethod != .get) {
            let encodedBody = try? JSONSerialization.data(withJSONObject: endpoint.body!)
            self.httpBody = encodedBody
        }
        if let headers = endpoint.headers {
            //map from [String: Any] to [String:String]
            let headersString = headers.mapValues { String(describing: $0) }
            //add value for each header
            for (header, value) in headersString {
                self.addValue(value, forHTTPHeaderField: header)
            }
        }
    }
}

func verifyURLResponse(_ response: URLResponse) throws {
    guard let httpResponse = response as? HTTPURLResponse else {
        throw APIError.unknown(status: 1000, errorMessage: "Couldn't cast URLResponse as HTTPURLResponse")
    }
    switch httpResponse.statusCode {
    case 200...299:
        return
    case 403, 401:
        throw APIError.notAuthorized(status: httpResponse.statusCode, errorMessage: "Not Authorized")
    case 400...499:
        throw APIError.badRequest(status: httpResponse.statusCode, errorMessage: "Bad Request")
    case 500...599:
        throw APIError.serverError(status: httpResponse.statusCode, errorMessage: "Internal error occured, please try again later.")
    default:
        throw APIError.unknown(status: 1000, errorMessage: "Error occured")
    }
}
