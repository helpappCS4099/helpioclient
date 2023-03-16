//
//  HelpWebRepository.swift
//  Help App
//
//  Created by Artem Rakhmanov on 16/03/2023.
//

import Foundation

protocol NewHelpRequestProtocol {
    func availableUsersRequest() async -> RepositoryResponse
}

protocol RESTHelpUpdateRequests {
    
}

class HelpWebRepository: WebRepository {
    var session = URLSession.shared
}

extension HelpWebRepository: NewHelpRequestProtocol {
    func availableUsersRequest() async -> RepositoryResponse {
        do {
            let endpoint = HelpRequestEndpoint.availableFriends
            let (responseData, _) = try await makeServerRequest(endpoint: endpoint, session: session)
            let availableFriendsModel = try JSONDecoder().decode(AvailableFriendsModel.self, from: responseData)
            if availableFriendsModel.message == "" {
                //success
                return .success(status: 200, model: availableFriendsModel)
            } else {
                return .success(status: 201, model: availableFriendsModel, errorMessage: availableFriendsModel.message)
            }
        } catch let error as APIError {
            print(error)
            return RepositoryResponse.failure(status: error.status, errorMessage: "API ERROR + \(error.status)")
        } catch {
            print(error)
            return RepositoryResponse.failure(status: 1000,
                                              errorMessage: "Investigate unexpected error at availableUsersRequest")
        }
    }
    
    
}
