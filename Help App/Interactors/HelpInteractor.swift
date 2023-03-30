//
//  HelpInteractor.swift
//  Help App
//
//  Created by Artem Rakhmanov on 16/03/2023.
//

import Foundation
import SwiftUI

protocol NewHelpRequestOperations {
    func getAvailableFriends() async -> ([FriendModel], OperationStatus)
    func createNewHelpRequest(category: Int, messages: [String], selectedFriendIDs: [String], friends: [FriendModel]) async -> (HelpRequestModel?, OperationStatus)
}

struct HelpInteractor {
    let appState: AppState
    let helpWebRepository: HelpWebRepository
}

extension HelpInteractor: NewHelpRequestOperations {
    
    func createNewHelpRequest(category: Int, messages: [String], selectedFriendIDs: [String], friends: [FriendModel]) async -> (HelpRequestModel?, OperationStatus) {
        // encode selected friends as respondents
        let respondents: [RespondentModel] = friends.filter{selectedFriendIDs.contains($0.userID)}.map { friend in
            let respondent = RespondentModel(friend: friend)
            return respondent
        }
        print(respondents)
        let newHelpRequestResponse = await helpWebRepository.postNewHelpRequest(category: category, messages: messages, respondents: respondents)
        switch newHelpRequestResponse {
        case .success(_, let model, _):
            guard let newHelpRequestModel = model as? HelpRequestModel else {
                return (nil, .failure(errorMessage: "could not cast help request model"))
            }
            
            //save to user defaults
            UserDefaults.standard.set(newHelpRequestModel.helpRequestID, forKey: "helpRequestID")
            UserDefaults.standard.set(true, forKey: "isInHelpRequest")
            UserDefaults.standard.set(false, forKey: "isRespondent")
            UserDefaults.standard.set(newHelpRequestModel.owner.userID, forKey: "userID")
            
            withAnimation {
                DispatchQueue.main.async {
                    //route through appstate
                    appState.helpRequestID = newHelpRequestModel.helpRequestID
                    appState.isRespondent = false
                    appState.showHelpRequest = true
                }
            }
            
            
            return (newHelpRequestModel, .success)
        case .failure(let status, _, let errorMessage):
            return (nil, .failure(errorMessage: errorMessage ?? "\(status) ; unexp error at newHR"))
        }
        
    }
    
    
    func getAvailableFriends() async -> ([FriendModel], OperationStatus) {
        let friendsResponse = await helpWebRepository.availableUsersRequest()
        switch friendsResponse {
        case .success(let status, let model, let errorMessage):
            if status == 200 {
                //friends are available
                guard let availableFriendsModel = model as? AvailableFriendsModel else {
                    return ([], .failure(errorMessage: "Could not cast model to avFriends"))
                }
                return (availableFriendsModel.friends, .success)
            } else {
                //no friends available
                return ([], .failure(errorMessage: errorMessage ?? "No Friends Available"))
            }
        case .failure(_, _, let errorMessage):
            return ([], .failure(errorMessage: errorMessage ?? "unexp error at getAvFriends"))
        }
    }
    
    func acceptHelpRequest(firstName: String, helpRequestID: String) {
        
        guard let userID = UserDefaults.standard.string(forKey: "userID") else {
            print("no userID in accept")
            return
        }
        
        SocketInteractor.standard.acceptHelpRequest(userID: userID, firstName: firstName)
        appState.helpRequestID = helpRequestID
        appState.isRespondent = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            appState.showHelpRequest = true
        }
    }
    
    func rejectHelpRequest(firstName: String) {
        guard let userID = UserDefaults.standard.string(forKey: "userID") else {
            print("no userID in accept")
            return
        }
        LocationTracker.standard.terminateLocationMonitoring()
        SocketInteractor.standard.rejectHelpRequest(userID: userID, firstName: firstName)
    }
    
    func sendSOS(helpRequestID: String) async -> Bool{
        let sosResponse = await helpWebRepository.sosRequest(helpRequestID: helpRequestID)
        switch sosResponse.status {
        case 200:
            return true
        default:
            return false
        }
    }
    
    //owner
    func resolveHelpRequest() {
        //socket method
        SocketInteractor.standard.resolveHelpRequest { status in
            //ack?
        }
        //reset app state
        appState.helpRequestID = ""
        appState.isRespondent = false
        appState.showHelpRequest = false
        LocationTracker.standard.terminateLocationMonitoring()
        //socket gets closed on "close" event
    }
    
    //respondent on owner resolve
    func closeOnResolutionHelpRequest() {
        appState.helpRequestID = ""
        appState.showHelpRequest = false
        SocketInteractor.standard.breakConnections()
        LocationTracker.standard.terminateLocationMonitoring()
    }
}
