//
//  UserWasCreatedModel.swift
//  Help App
//
//  Created by Artem Rakhmanov on 19/02/2023.
//

import Foundation

struct UserWasCreatedModel: Codable, ResponseModel {
    let userWasCreated: Bool
    let userID: String?
}
