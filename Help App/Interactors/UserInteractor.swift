//
//  File.swift
//  Help App
//
//  Created by Artem Rakhmanov on 08/03/2023.
//

import Foundation

protocol UserOperations {
    func getMyself() async -> (UserModel?, OperationStatus)
    func getUser(userID: String) async -> (UserModel?, OperationStatus)
    func searchUsers(by searchString: String, myUserID: String) async -> ([UserModel], OperationStatus)
}

protocol FriendOperations {
    func addFriend(myUserID: String, friendUserID: String)
        async -> (UserModel?, String?, OperationStatus)
    func deleteFriend(myUserID: String, friendUserID: String)
        async -> (UserModel?, String?, OperationStatus)
}

struct UserInteractor {
    let appState: AppState
    let userWebRepository: UserWebRepository
}

extension UserInteractor: UserOperations {
    
    func getMyself() async -> (UserModel?, OperationStatus) {
        let myUserObjectResponse = await userWebRepository.myUserObjectRequest()
        switch myUserObjectResponse {
        case .success(_, let model, _):
            guard let userObject = model as? UserModel else {
                return (nil, .failure(errorMessage: "Could not cast model to userObject at getMyself()"))
            }
            return (userObject, .success)
        case .failure(_, _, let errorMessage):
            return (nil, .failure(errorMessage: errorMessage!))
        }
    }
    
    func getUser(userID: String) async -> (UserModel?, OperationStatus) {
        let userObjectResponse = await userWebRepository.getUserRequest(userID: userID)
        switch userObjectResponse {
        case .success(_, let model, _):
            guard let userObject = model as? UserModel else {
                return (nil, .failure(errorMessage: "Could not cast model to userObject at getUser()"))
            }
            return (userObject, .success)
        case .failure(_, _, let errorMessage):
            return (nil, .failure(errorMessage: errorMessage!))
        }
    }
    
    func searchUsers(by searchString: String, myUserID: String) async -> ([UserModel], OperationStatus) {
        let searchResponse = await userWebRepository.searchUsersRequest(searchString: searchString)
        switch searchResponse {
        case .success(_, let model, _):
            guard let searchResults = model as? SearchResultsModel else {
                return ([], .failure(errorMessage: "Could not cast model to userObject at search()"))
            }
            print(searchResults)
            return (searchResults.searchResults.filter{$0.userID != myUserID}, .success)
        case .failure(_, _, let errorMessage):
            return ([], .failure(errorMessage: errorMessage!))
        }
    }
    
    func convertUsersToFriends(for user: UserModel, with users: [UserModel]) -> [FriendModel] {
        let userID = user.userID
        //current friends
        let friends = user.friends
        let friendIDs = friends.map{$0.userID}
//        friends.first(where: {$0.userID == userID})?.status
        let status: (UserModel) -> Int = { user in
            if user.friends.contains(where: { $0.userID == userID}) {
                let usersStatus = user.friends.first(where: {$0.userID == userID})!.status
                switch usersStatus {
                case 2:
                    return 3
                case 3:
                    return 2
                default:
                    return usersStatus
                }
            } else {
                return 0
            }
        }
        let result = users.map {
            return FriendModel(
                userID: $0.userID,
                firstName: $0.firstName,
                lastName: $0.lastName,
                colorScheme: $0.colorScheme,
                status: status($0),
                email: $0.email
            )
        }
        return result
    }
    
    
}

extension UserInteractor: FriendOperations {
    func addFriend(myUserID: String, friendUserID: String) async -> (UserModel?,
                                                                     String?,
                                                                     OperationStatus) {
        let friendRequestResponse = await userWebRepository.addFriendRequest(myUserID: myUserID, friendUserID: friendUserID)
        switch friendRequestResponse {
        case .success(_, let model, _):
            guard let responseModel = model as? FriendRequestResponseModel else {
                return (nil, "Could not add a friend. Please try again later.", .failure(errorMessage: "Could not cast model to userObject at addFriend()"))
            }
            return (responseModel.user, responseModel.message, .success)
        case .failure(_, _, let errorMessage):
            return (nil, errorMessage, .failure(errorMessage: errorMessage!))
        }
    }
    
    func deleteFriend(myUserID: String, friendUserID: String) async -> (UserModel?,
                                                                        String?,
                                                                        OperationStatus) {
        let friendRemovalResponse = await userWebRepository.deleteFriendRequest(myUserID: myUserID, friendUserID: friendUserID)
        switch friendRemovalResponse {
        case .success(_, let model, _):
            guard let responseModel = model as? FriendRequestResponseModel else {
                return (nil, "Could not remove a friend. Please try again later.", .failure(errorMessage: "Could not cast model to userObject at addFriend()"))
            }
            return (responseModel.user, responseModel.message, .success)
        case .failure(_, _, let errorMessage):
            return (nil, errorMessage, .failure(errorMessage: errorMessage!))
        }
    }
    
    
}
