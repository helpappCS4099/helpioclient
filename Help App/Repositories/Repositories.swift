//
//  Repositories.swift
//  Help App
//
//  Created by Artem Rakhmanov on 16/02/2023.
//

import Foundation

class Repositories {
    
    init() {
        self.session = SessionWebRepository()
        self.user = UserWebRepository()
        self.help = HelpWebRepository()
    }
    
    let session: SessionWebRepository
    let user: UserWebRepository
    let help: HelpWebRepository
}

extension Repositories {
    static func bootstrap() -> Repositories {
        return Repositories()
    }
}

class WebRepository {
    func makeServerRequest(endpoint: Endpoint, session: URLSession)
    async throws -> (Data, URLResponse) {
        let urlRequest = URLRequest(endpoint: endpoint)!
        let (responseData, response) = try await session.data(for: urlRequest)
        print("verifying..")
        try verifyURLResponse(response)
        print("verified")
        return (responseData, response)
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
}
