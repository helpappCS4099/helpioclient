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

class SessionWebRepository: WebRepository {
    let queue = DispatchQueue(label: "bg_parse_queue")
    var session = URLSession.shared
}

extension SessionWebRepository: SessionWebRequests {
    func logInRequest(email: String, password: String) async -> RepositoryResponse {
        do {
            print("login request")
            let endpoint = SessionEndpoints.login(email, password)
            let (responseData, _) = try await makeServerRequest(endpoint: endpoint, session: session)
            
            print("login request came back")
            
            let loginUserModel = try JSONDecoder().decode(LoginUserModel.self, from: responseData)
            
            print(loginUserModel)
            
            return RepositoryResponse.success(status: 200, model: loginUserModel)
            
        } catch let error as APIError {
            print(error)
            return RepositoryResponse.failure(status: error.status, errorMessage: error.errorMessage)
        } catch {
            print(error)
            return RepositoryResponse.failure(status: 1000,
                                              errorMessage: "Investigate unexpected error at logInRequest")
        }
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
            let (responseData, _) = try await makeServerRequest(endpoint: endpoint, session: session)
            //user response model object JSON serialization
            let userWasCreatedModel = try JSONDecoder().decode(UserWasCreatedModel.self, from: responseData)
            //return RepositoryResponse
            print(userWasCreatedModel)
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
            let (responseData, response) = try await makeServerRequest(endpoint: endpoint, session: session)
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
        do {
            let endpoint = AccountCreationEndpoints.checkEmailVerification
            let (responseData, response) = try await makeServerRequest(endpoint: endpoint, session: session)
            print(responseData)
            let emailVerificationModel = try? JSONDecoder().decode(EmailVerificationModel.self, from: responseData)
            return RepositoryResponse.success(status: 200, model: emailVerificationModel)
        } catch let error as APIError {
            print(error)
            return RepositoryResponse.failure(status: error.status, errorMessage: error.errorMessage)
        } catch {
            print(error)
            return RepositoryResponse.failure(status: 1000,
                                              errorMessage: "Investigate unexpected error at checkEmailverificationRequest")
        }
    }
    
}
