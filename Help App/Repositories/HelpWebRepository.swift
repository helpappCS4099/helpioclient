//
//  HelpWebRepository.swift
//  Help App
//
//  Created by Artem Rakhmanov on 16/03/2023.
//

import Foundation

protocol NewHelpRequestProtocol {
    func availableUsersRequest() async -> RepositoryResponse
    
    func postNewHelpRequest(
        category: Int,
        messages: [String],
        respondents: [RespondentModel]
    ) async -> RepositoryResponse
}

protocol RESTHelpUpdateRequests {
    
}

class HelpWebRepository: WebRepository {
    var session = URLSession.shared
}

extension HelpWebRepository: NewHelpRequestProtocol {
    
    func postNewHelpRequest(category: Int, messages: [String], respondents: [RespondentModel]) async -> RepositoryResponse {
        do {
            let endpoint = HelpRequestEndpoint.newHelpRequest(
                category: category,
                messages: messages,
                respondents: respondents)
            
            let (responseData, _) = try await makeServerRequest(endpoint: endpoint, session: session)
            let newHelpRequestModel = try JSONDecoder().decode(HelpRequestModel.self, from: responseData)
            return .success(status: 200, model: newHelpRequestModel, errorMessage: "")
        
        } catch let error as APIError {
            print(error)
            return RepositoryResponse.failure(status: error.status, errorMessage: "API ERROR + \(error.status)")
        } catch {
            print(error)
            return RepositoryResponse.failure(status: 1000,
                                              errorMessage: "Investigate unexpected error at postHelpReq")
        }
    }
    
    func pushLocationRequest(helpRequestID: String, userID: String, latitude: Double, longitude: Double) async -> RepositoryResponse {
        do {
            let endpoint = HelpRequestEndpoint.location(helpRequestID: helpRequestID, userID: userID, latitude: latitude, longitude: longitude)
            let (_, _) = try await makeServerRequest(endpoint: endpoint, session: session)
            
            return .success(status: 200)
            
        } catch let error as APIError {
            print(error)
            return RepositoryResponse.failure(status: error.status, errorMessage: "API ERROR + \(error.status)")
        } catch {
            print(error)
            return RepositoryResponse.failure(status: 1000,
                                              errorMessage: "Investigate unexpected error at availableUsersRequest")
        }
    }
    
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
    
    func sosRequest(helpRequestID: String) async -> RepositoryResponse {
        do {
            let endpoint = HelpRequestEndpoint.sos(helpRequestID: helpRequestID)
            let (responseData, error) = try await makeServerRequest(endpoint: endpoint, session: session)
            
            return .success(status: 200)
            
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
