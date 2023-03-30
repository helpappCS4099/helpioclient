//
//  HelpRequest.swift
//  Help App
//
//  Created by Artem Rakhmanov on 24/03/2023.
//

import SwiftUI
import MapKit

class HelpRequestState: ObservableObject {
    
    init() {
        let hrModel: HelpRequestModel = HelpRequestModel(helpRequestID: "jskjdls", owner: .init(userID: "sdjklkjsdldsld", firstName: "Artem", lastName: "Rakhmanov", colorScheme: 1),
            messages: [
                MessageModel(
                    messageID: "dhskjdsdsdhls",
                    userID: "djskljljsd",
                    firstName: "Artem",
                    colorScheme: 1,
                    isAudio: false,
                    body: "Testing messaging",
                    timeStamp: Date().toString(),
                    data: nil)
            
            ], isResolved: false, category: 2, currentStatus: .init(progressStatus: 0, progressMessageOwner: "Notifications sent. Hold on for a moment.", progressMessageRespondent: "Artem "), startTime: "2023-03-18T14:36:39.927Z", endTime: nil, location: [
            
                LocationPointModel(latitude: 56.340876, longitude: -2.800757, time: "2023-03-29T10:03:44.032Z")
            
            ],
            respondents: [
                RespondentModel(
                    userID: "djksljslds",
                    firstName: "Altyn",
                    lastName: "Orazgulyyeva",
                    colorScheme: 4,
                    status: 0,
                    location: [
                        LocationPointModel(latitude: 56.33908399840691, longitude: -2.8002410057005633, time: "2023-03-29T10:03:44.032Z")
                    ]),
                RespondentModel(
                    userID: "djksljsldsdssds",
                    firstName: "Mykyta",
                    lastName: "Rakhmanov",
                    colorScheme: 2,
                    status: 1,
                    location: [
                        LocationPointModel(latitude: 56.340863, longitude: -2.795536, time: "2023-03-29T10:03:44.032Z")
                    ]),
                RespondentModel(
                    userID: "djksljsldsdssdssas",
                    firstName: "Konstantin",
                    lastName: "Nazarov",
                    colorScheme: 1,
                    status: 2,
                    location: [
                        LocationPointModel(latitude: 56.341125, longitude: -2.798293, time: "2023-03-29T10:03:44.032Z")
                    ]),
                RespondentModel(
                    userID: "djksljsldsdssdssasssa",
                    firstName: "Bob",
                    lastName: "Maker",
                    colorScheme: 3,
                    status: -1,
                    location: [
                        LocationPointModel(latitude: 56.341125, longitude: -2.798293, time: "2023-03-29T10:03:44.032Z")
                    ]),
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
    
    init(id: String, userID: String) {
        self.helpRequestID = id
        self.myUserID = userID
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
    
    func getOwnerCoordinateRegion() -> MKCoordinateRegion? {
        if let location = location.last {
            return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: Double(location.latitude), longitude: Double(location.longitude)), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        } else {
            return nil
        }
        
    }
    
    
    //display respondents for owner
    func getRespondentMapItems() -> [AnnotationItem] {
        var result: [AnnotationItem] = []
        for respondent in respondents {
            if let lastLocationPoint = respondent.location.last {
                result.append(
                    AnnotationItem(
                        latitude: Double(lastLocationPoint.latitude),
                        longitude: Double(lastLocationPoint.longitude),
                        thumbnailLetters: respondent.firstName[0].capitalized + respondent.lastName[0].capitalized,
                        colorScheme: respondent.colorScheme,
                        userID: respondent.userID
                    )
                )
            } else {
                continue
            }
        }
        return result
    }
    
    //display owner (for thumbnail & prompt)
    func getOwnerMapItem() -> [AnnotationItem] {
        if let location = self.location.last {
            return [AnnotationItem(
                latitude: Double(location.latitude),
                longitude: Double(location.longitude),
                thumbnailLetters: (owner?.firstName[0].capitalized ?? "") + (owner?.lastName[0].capitalized ?? ""),
                colorScheme: owner?.colorScheme ?? 1,
                userID: owner?.userID ?? ""
            )]
        } else {
            return []
        }
        
    }
    
    //display all locations except self
    func getAllMapItemsWithoutMe() -> [AnnotationItem] {
        var result: [AnnotationItem] = getOwnerMapItem()
        for respondent in respondents {
            if respondent.userID != myUserID {
                if let lastLocationPoint = respondent.location.last {
                    result.append(
                        AnnotationItem(
                            latitude: Double(lastLocationPoint.latitude),
                            longitude: Double(lastLocationPoint.longitude),
                            thumbnailLetters: respondent.firstName[0].capitalized + respondent.lastName[0].capitalized,
                            colorScheme: respondent.colorScheme,
                            userID: respondent.userID
                        )
                    )
                } else {
                    continue
                }
            }
        }
        return result
    }
    
    func myName() -> String {
        if userIsOwner() {
            return owner?.firstName ?? "FirstN"
        } else {
            let index = respondentIndex()
            return respondents[index].firstName
        }
    }
    
    func mySurname() -> String {
        if userIsOwner() {
            return "Surname"
        } else {
            let index = respondentIndex()
            return respondents[index].lastName
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
        if respondents.count == 0 {
            return 0
        }
        if let index = respondents.firstIndex(where: {$0.userID == myUserID}) {
            return index
        } else {
            return 0
        }
    }
    
    func myStatus() -> Int {
        if respondents.count == 0 {
            return 0
        }
        return self.respondents[self.respondentIndex()].status
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

class AnnotationItem: Identifiable, Equatable {
    
    static func == (lhs: AnnotationItem, rhs: AnnotationItem) -> Bool {
        return lhs.coordinate.latitude == rhs.coordinate.latitude && rhs.coordinate.longitude == lhs.coordinate.longitude
    }
    
    internal init(latitude: Double, longitude: Double, thumbnailLetters: String, colorScheme: Int, userID: String) {
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.thumbnailLetters = thumbnailLetters
        self.colorScheme = colorScheme
        self.userID = userID
    }
    
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let thumbnailLetters: String
    let colorScheme: Int
    let userID: String
    
    func getMKMapRectRegion() -> MKCoordinateRegion {
        let region = MKCoordinateRegion(
            center: self.coordinate,
            span: MKCoordinateSpan(
                latitudeDelta: 0.01,
                longitudeDelta: 0.01)
        )
        var offsetCoordinate = coordinate
        let span = region.span
        offsetCoordinate.latitude = coordinate.latitude - span.latitudeDelta * 1/5
        let offsetRegion = MKCoordinateRegion(center: offsetCoordinate, span: span)
        return offsetRegion
    }
    
    func getDistanceToUser() -> String {
        if let userLocation = LocationTracker.standard.cl.location {
            let pointLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            return String("\(Int(pointLocation.distance(from: userLocation)))m")
        } else {
            return ""
        }
    }
}
