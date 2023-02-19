//
//  AuthenticationWebRepository.swift
//  Help App
//
//  Created by Artem Rakhmanov on 09/02/2023.
//

import Foundation

protocol SessionWebRequests {
    func logInRequest(email: String,
               password: String)
        async -> RepositoryResponse
    
    func logOutRequest()
        async -> RepositoryResponse
    
    func updateAPNTokenRequest(deviceToken: String)
        async -> RepositoryResponse
    
    func createNewUserRequest(email: String,
                       password: String,
                       firstName: String,
                       lastName: String)
        async -> RepositoryResponse
    
    func checkEmailRequest(email: String)
        async -> RepositoryResponse
    
    func resendVerificationEmailRequest()
        async -> RepositoryResponse
    
    func checkEmailVerificationRequest()
        async -> RepositoryResponse
}

struct SessionWebRepository {
    let queue = DispatchQueue(label: "bg_parse_queue")
    var session = URLSession.shared
}

extension SessionWebRepository: SessionWebRequests {
    func logInRequest(email: String, password: String) async -> RepositoryResponse {
        return .success(status: 200)
    }
    
    func logOutRequest() async -> RepositoryResponse {
        return .success(status: 200)
    }
    
    func updateAPNTokenRequest(deviceToken: String) async -> RepositoryResponse {
        return .success(status: 200)
    }
    
    func createNewUserRequest(email: String, password: String, firstName: String, lastName: String) async -> RepositoryResponse {
        do {
            let endpoint = AccountCreationEndpoints.createUser(email: email,
                                                               password: password,
                                                               firstName: firstName,
                                                               lastName: lastName)
            let urlRequest = URLRequest(endpoint: endpoint)!
            let (responseData, response) = try await session.data(for: urlRequest)
            try verifyURLResponse(response)
            //user response model object JSON serialization
            let userWasCreatedModel = try JSONDecoder().decode(UserWasCreatedModel.self, from: responseData)
            //return RepositoryResponse
            return RepositoryResponse.success(status: 200, model: userWasCreatedModel)
            
        } catch let error as APIError {
            return RepositoryResponse.failure(status: error.status, errorMessage: error.errorMessage)
        } catch {
            print(error)
            return RepositoryResponse.failure(status: 1000,
                                              errorMessage: "Investigate unexpected error at createNewUserRequest")
        }
    }
    
    func checkEmailRequest(email: String) async -> RepositoryResponse {
        do {
            let endpoint = AccountCreationEndpoints.checkEmail(email)
            let urlRequest = URLRequest(endpoint: endpoint)!
            let (responseData, response) = try await session.data(for: urlRequest)
            try verifyURLResponse(response)
            let emailAvailability = try JSONDecoder().decode(EmailAvailability.self, from: responseData)
            
            return RepositoryResponse.success(status: 200, model: emailAvailability)
            
        } catch let error as APIError {
            return RepositoryResponse.failure(status: error.status, errorMessage: error.errorMessage)
        } catch {
            print(error)
            return RepositoryResponse.failure(status: 1000,
                                              errorMessage: "Investigate unexpected error at checkEmailRequest")
        }
    }
    
    func resendVerificationEmailRequest() async -> RepositoryResponse {
        return .success(status: 200)
    }
    
    func checkEmailVerificationRequest() async -> RepositoryResponse {
        return .success(status: 200)
    }
    
}
