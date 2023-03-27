//
//  HelpRequest.swift
//  Help App
//
//  Created by Artem Rakhmanov on 24/03/2023.
//

import SwiftUI

class HelpRequestState: ObservableObject {
    
    init() {
        let hrModel: HelpRequestModel = HelpRequestModel(helpRequestID: "jskjdls", owner: .init(userID: "sdjklkjsdldsld", firstName: "Artem", lastName: "Rakhmanov", colorScheme: 1), messages: [], isResolved: false, category: 2, currentStatus: .init(progressStatus: 0, progressMessageOwner: "Notifications sent. Hold on for a moment.", progressMessageRespondent: "Artem "), startTime: "2023-03-18T14:36:39.927Z", endTime: nil, location: [],
            respondents: [
                RespondentModel(
                    userID: "djksljslds",
                    firstName: "Altyn",
                    lastName: "Orazgulyyeva",
                    colorScheme: 4,
                    status: 0,
                    location: []),
                RespondentModel(
                    userID: "djksljsldsdssds",
                    firstName: "Mykyta",
                    lastName: "Rakhmanov",
                    colorScheme: 2,
                    status: 1,
                    location: []),
                RespondentModel(
                    userID: "djksljsldsdssdssas",
                    firstName: "Konstantin",
                    lastName: "Nazarov",
                    colorScheme: 1,
                    status: 2,
                    location: []),
                RespondentModel(
                    userID: "djksljsldsdssdssasssa",
                    firstName: "Bob",
                    lastName: "Maker",
                    colorScheme: 3,
                    status: -1,
                    location: []),
            ]
        )
        
        self.helpRequestID = hrModel.helpRequestID
        self.owner = hrModel.owner
        self.messages = hrModel.messages
        self.isResolved = hrModel.isResolved
        self.category = hrModel.category
        self.currentStatus = hrModel.currentStatus
        self.startTime = hrModel.startTime
        self.endTime = hrModel.endTime
        self.location = hrModel.location
        self.respondents = hrModel.respondents
    }
    
    init(model: HelpRequestModel) {
        self.helpRequestID = model.helpRequestID
        self.owner = model.owner
        self.messages = model.messages
        self.isResolved = model.isResolved
        self.category = model.category
        self.currentStatus = model.currentStatus
        self.startTime = model.startTime
        self.endTime = model.endTime
        self.location = model.location
        self.respondents = model.respondents
    }
    
    init(id: String) {
        self.helpRequestID = id
        self.owner = nil
        self.messages = []
        self.isResolved = nil
        self.category = nil
        self.currentStatus = nil
        self.startTime = nil
        self.endTime = nil
        self.location = []
        self.respondents = []
    }
    
    func updateFields(model: HelpRequestModel) {
        self.helpRequestID = model.helpRequestID
        self.owner = model.owner
        self.messages = model.messages
        self.isResolved = model.isResolved
        self.category = model.category
        self.currentStatus = model.currentStatus
        self.startTime = model.startTime
        self.endTime = model.endTime
        self.location = model.location
        self.respondents = model.respondents
    }
    
    func myName() -> String {
        if userIsOwner() {
            return owner?.firstName ?? "FirstN"
        } else {
            let index = respondentIndex()
            return respondents[index].firstName
        }
    }
    
    func myColorScheme() -> Int {
        if userIsOwner() {
            return owner?.colorScheme ?? 1
        } else {
            let index = respondentIndex()
            return respondents[index].colorScheme
        }
    }
    
    func userIsOwner() -> Bool {
        return myUserID == owner?.userID
    }
    
    func respondentIndex() -> Int {
        if let index = respondents.firstIndex(where: {$0.userID == myUserID}) {
            return index
        } else {
            return 0
        }
    }
    
    @Published var helpRequestID: String?
    @Published var owner: OwnerModel?
    @Published var messages: [MessageModel]
    @Published var isResolved: Bool?
    @Published var category: Int?
    @Published var currentStatus: HelpRequestStatusModel?
    @Published var startTime: String?   //parse date
    @Published var endTime: String?    //parse date
    @Published var location: [LocationPointModel]
    @Published var respondents: [RespondentModel]
    
    @Published var myUserID: String = UserDefaults.standard.string(forKey: "userID") ?? ""
}
