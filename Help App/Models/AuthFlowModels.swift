//
//  AuthFlowModels.swift
//  Help App
//
//  Created by Artem Rakhmanov on 20/02/2023.
//

import Foundation

//response from checking email availability
struct EmailAvailability: Codable, ResponseModel {
    let emailIsAvailable: Bool
}

//response after creating a user
struct UserWasCreatedModel: Codable, ResponseModel {
    let userWasCreated: Bool
    let userID: String?
}

//response for user login user object
struct UserModel: Codable, ResponseModel {
    let email: String
    let firstName: String
    let lastName: String
    let verified: Bool
    let deviceToken: String
    //add friends here
}

//response after login
struct LoginUserModel: Codable, ResponseModel {
    let authenticated: Bool
    let userID: String?
    let user: UserModel?
}

//response for checking email verification
struct EmailVerificationModel: Codable, ResponseModel {
    let userIsVerified: Bool
}
