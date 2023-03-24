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

struct MessageModel: Codable, ResponseModel {
    let messageID: String
    let userID: String
    let firstName: String
    let colorScheme: Int
    let isAudio: Bool
    let body: String
    let timeStamp: String
    let data: Data?
}

struct RespondentModel: Codable, ResponseModel {
    internal init(userID: String, firstName: String, lastName: String, colorScheme: Int, status: Int, location: [LocationPointModel]) {
        self.userID = userID
        self.firstName = firstName
        self.lastName = lastName
        self.colorScheme = colorScheme
        self.status = status
        self.location = location
    }
    
    
    init(friend: FriendModel) {
        self.userID = friend.userID
        self.firstName = friend.firstName
        self.lastName = friend.lastName
        self.colorScheme = friend.colorScheme
        self.status = 0
        self.location = []
    }
    
    
    
    let userID: String
    let firstName: String
    let lastName: String
    let colorScheme: Int
    let status: Int
    let location: [LocationPointModel]
    
    func convertToDictionary() -> Dictionary<String, Any> {
                return [
                    "userID" : self.userID,
                    "firstName" : self.firstName,
                    "lastName" : self.lastName,
                    "colorScheme" : self.colorScheme,
                    "status" : self.status,
                    "location" : self.location.map({ loc in
                        return loc.convertToDictionary()
                    })
                ]
            }
}

struct NewHelpRequestModel: Codable, ResponseModel {
    let category: Int
    let messages: [String]
    let respondents: [RespondentModel]
}

struct LocationPointModel: Codable, ResponseModel {
    let latitude: Float
    let longitude: Float
    let time: String
    
    func convertToDictionary() -> Dictionary<String, Any> {
        return [
            "latitude" : self.latitude,
            "longitude" : self.longitude,
            "time" : self.time
        ]
    }
}

struct HelpRequestStatusModel: Codable, ResponseModel {
    let progressStatus: Int
    let progressMessageOwner: String
    let progressMessageRespondent: String
}

struct OwnerModel: Codable, ResponseModel {
    let userID: String
    let firstName: String
    let lastName: String
    let colorScheme: Int
}

struct HelpRequestModel: Codable, ResponseModel {
    let helpRequestID: String
    let owner: OwnerModel
    let messages: [MessageModel]
    let isResolved: Bool
    let category: Int
    let currentStatus: HelpRequestStatusModel
    let startTime: String   //parse date
    let endTime: String?    //parse date
    let location: [LocationPointModel]
    let respondents: [RespondentModel]
}
