//
//  HelpInteractor.swift
//  Help App
//
//  Created by Artem Rakhmanov on 16/03/2023.
//

import Foundation

protocol NewHelpRequestOperations {
    func getAvailableFriends() async -> ([FriendModel], OperationStatus)
}

struct HelpInteractor {
    let appState: AppState
    let helpWebRepository: HelpWebRepository
}

extension HelpInteractor: NewHelpRequestOperations {
    
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
