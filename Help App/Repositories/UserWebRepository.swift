//
//  UserWebRepository.swift
//  Help App
//
//  Created by Artem Rakhmanov on 08/03/2023.
//

import Foundation

protocol UserWebRequests {
    func myUserObjectRequest() async -> RepositoryResponse
    func getUserRequest(userID: String) async -> RepositoryResponse
    func searchUsersRequest(searchString: String) async -> RepositoryResponse
    func addFriendRequest(myUserID: String, friendUserID: String) async -> RepositoryResponse
    func deleteFriendRequest(myUserID: String, friendUserID: String) async -> RepositoryResponse
}

class UserWebRepository: WebRepository {
    let queye = DispatchQueue(label: "bg_parse_queue")
    var session = URLSession.shared
}

extension UserWebRepository: UserWebRequests {
    func myUserObjectRequest() async -> RepositoryResponse {
        do {
            let endpoint = UserEndpoints.me
            let (responseData,_) = try await makeServerRequest(endpoint: endpoint, session: session)
            let userObject = try JSONDecoder().decode(UserModel.self, from: responseData)
            return RepositoryResponse.success(status: 200, model: userObject)
        } catch let error as APIError {
            return RepositoryResponse.failure(status: error.status, errorMessage: error.errorMessage)
        } catch {
            print(error)
            return RepositoryResponse.failure(status: 1000,
                                              errorMessage: "Investigate unexpected error at myUserObjReq")
        }
    }
    
    func getUserRequest(userID: String) async -> RepositoryResponse {
        do {
            let endpoint = UserEndpoints.user(userID: userID)
            let (responseData,_) = try await makeServerRequest(endpoint: endpoint, session: session)
            let userObject = try JSONDecoder().decode(UserModel.self, from: responseData)
            return RepositoryResponse.success(status: 200, model: userObject)
        } catch let error as APIError {
            return RepositoryResponse.failure(status: error.status, errorMessage: error.errorMessage)
        } catch {
            print(error)
            return RepositoryResponse.failure(status: 1000,
                                              errorMessage: "Investigate unexpected error at getUserReq")
        }
    }
    
    func searchUsersRequest(searchString: String) async -> RepositoryResponse {
        do {
            let endpoint = UserEndpoints.search(searchString: searchString)
            let (responseData, _) = try await makeServerRequest(endpoint: endpoint, session: session)
            let searchResults = try JSONDecoder().decode(SearchResultsModel.self, from: responseData)
            return RepositoryResponse.success(status: 200, model: searchResults)
        } catch let error as APIError {
            return RepositoryResponse.failure(status: error.status, errorMessage: error.errorMessage)
        } catch {
            print(error)
            return RepositoryResponse.failure(status: 1000,
                                              errorMessage: "Investigate unexpected error at searchReq")
        }
    }
    
    func addFriendRequest(myUserID: String, friendUserID: String) async -> RepositoryResponse {
        do {
            let endpoint = UserEndpoints.addFriend(myUserID: myUserID, friendUserID: friendUserID)
            let (responseData, _) = try await makeServerRequest(endpoint: endpoint, session: session)
            print("addFriendResponse", responseData)
            let friendRequestResponse = try JSONDecoder().decode(FriendRequestResponseModel.self, from: responseData)
            
            return RepositoryResponse.success(status: 200, model: friendRequestResponse)
            
        } catch let error as APIError {
            return RepositoryResponse.failure(status: error.status, errorMessage: error.errorMessage)
        } catch {
            print(error)
            return RepositoryResponse.failure(status: 1000,
                                              errorMessage: "Investigate unexpected error at addFriendReq")
        }
    }
    
    func deleteFriendRequest(myUserID: String, friendUserID: String) async -> RepositoryResponse {
        do {
            let endpoint = UserEndpoints.deleteFriend(myUserID: myUserID, friendUserID: friendUserID)
            let (responseData, _) = try await makeServerRequest(endpoint: endpoint, session: session)
            let friendRequestResponse = try JSONDecoder().decode(FriendRequestResponseModel.self, from: responseData)
            
            return RepositoryResponse.success(status: 200, model: friendRequestResponse)
        } catch let error as APIError {
            return RepositoryResponse.failure(status: error.status, errorMessage: error.errorMessage)
        } catch {
            print(error)
            return RepositoryResponse.failure(status: 1000,
                                              errorMessage: "Investigate unexpected error at addFriendReq")
        }
    }
}
