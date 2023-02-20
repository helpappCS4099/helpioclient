//
//  UserModel.swift
//  Help App
//
//  Created by Artem Rakhmanov on 20/02/2023.
//

import Foundation

struct UserModel: Codable, ResponseModel {
    let email: String
    let firstName: String
    let lastName: String
    let verified: Bool
    let deviceToken: String
    //add friends here
}
