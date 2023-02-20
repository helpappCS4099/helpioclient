//
//  LoginUserModel.swift
//  Help App
//
//  Created by Artem Rakhmanov on 20/02/2023.
//

import Foundation

struct LoginUserModel: Codable, ResponseModel {
    let authenticated: Bool
    let userID: String?
    let user: UserModel?
}


