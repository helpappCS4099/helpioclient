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
