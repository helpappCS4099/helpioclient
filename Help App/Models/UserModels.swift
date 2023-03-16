//
//  UserModels.swift
//  Help App
//
//  Created by Artem Rakhmanov on 08/03/2023.
//

import Foundation

//struct Use
//response for user login user object
struct UserModel: Codable, ResponseModel {
    let userID: String
    let email: String
    let firstName: String
    let lastName: String
    let verified: Bool
    let myCurrentHelpRequestID: String
    let respondingCurrentHelpRequestID: String
    let colorScheme: Int
    let friends: [FriendModel]
}

struct SearchUserModel: Codable, ResponseModel {
    let _id: String
    let email: String
    let firstName: String
    let lastName: String
    let verified: Bool
    let myCurrentHelpRequestID: String
    let respondingCurrentHelpRequestID: String
    let colorScheme: Int
    let friends: [FriendModel]
}

struct FriendModel: Codable, ResponseModel {
    let userID: String
    let firstName: String
    let lastName: String
    let colorScheme: Int
    let status: Int //friend status
    let email: String
}

struct SearchResultsModel: Codable, ResponseModel {
    let searchResults: [UserModel]
}

struct FriendRequestResponseModel: Codable, ResponseModel {
    let message: String
    let user: UserModel
}

struct RequestErrorMessageModel: Codable, ResponseModel {
    let message: String
}
