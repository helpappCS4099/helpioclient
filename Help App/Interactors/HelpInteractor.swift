//
//  HelpInteractor.swift
//  Help App
//
//  Created by Artem Rakhmanov on 16/03/2023.
//

import Foundation

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
    
}
