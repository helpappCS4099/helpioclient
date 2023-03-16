//
//  HelpRequestModels.swift
//  Help App
//
//  Created by Artem Rakhmanov on 16/03/2023.
//

import Foundation

struct AvailableFriendsModel: Codable, ResponseModel {
    let message: String
    let friends: [FriendModel]
}

struct NewMessageModel: Codable, ResponseModel {
    let userID: String
    let firstName: String
    let colorScheme: Int
    let isAudio: Bool
    let body: String
    let data: Data?
}

struct RespondentModel: Codable, ResponseModel {
    let userID: String
    let firstName: String
    let lastName: String
    let colorScheme: Int
    let status: Int
    let location: [LocationPointModel]
}

struct NewHelpRequestModel: Codable, ResponseModel {
    let category: Int
    let messages: [NewMessageModel]
    let respondents: [RespondentModel]
}

struct LocationPointModel: Codable, ResponseModel {
    let latitude: Float
    let longitude: Float
    let time: Date?
}
