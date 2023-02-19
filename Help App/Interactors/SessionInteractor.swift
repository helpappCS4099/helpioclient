//
//  AuthenticationInteractor.swift
//  Help App
//
//  Created by Artem Rakhmanov on 02/02/2023.
//

import Foundation

protocol SessionOperations {
    
    func logIn(email: String,
               password: String)
        async -> OperationStatus
    
    func logOut()
        async -> OperationStatus
    
    func updateAPNToken(deviceToken: String)
        async -> OperationStatus
}

protocol NewUserCreation {
    
    func createNewUser(email: String,
                       password: String,
                       firstName: String,
                       lastName: String)
        async -> OperationStatus
    
    func checkEmail(email: String)
        async -> (Bool,OperationStatus)
    
    func resendVerificationEmail()
        async -> OperationStatus
    
    func checkEmailVerification()
        async -> OperationStatus
    
}

struct SessionInteractor {
    let appState: AppState
    let sessionWebRepository: SessionWebRepository
}

extension SessionInteractor {
    
    func checkEmail(email: String) async -> (Bool,OperationStatus) {
        //check email format (regex)
        let status = isValidEmail(email: email)
        switch status {
        case true:
            break
        case false:
            return (false, .failure(errorMessage: "Please enter a valid St Andrews email."))
        }
        //query DB if email is available
        let repositoryResponse = await sessionWebRepository.checkEmailRequest(email: email)
        switch repositoryResponse {
        case .success(_, let model, _):
            guard let emailAvailability = model as? EmailAvailability else {
                return (false, .failure(errorMessage: "We are having problems right now... Please try later :("))
            }
            if emailAvailability.emailIsAvailable {
                return (true, .success)
            } else {
                return (false, .success)
            }
        case .failure(_, _, let errorMessage):
            return (false, .failure(errorMessage: errorMessage ?? "There is an account with such email. Would you like to sign in?"))
        }
    }
    
    func createNewUser(email: String,
                       password: String,
                       firstName: String,
                       lastName: String) async -> OperationStatus {
        //email is valid
        //password, firstname and lastname are nonempty
        //request
        let response = await sessionWebRepository.createNewUserRequest(email: email,
                                                                 password: password,
                                                                 firstName: firstName,
                                                                 lastName: lastName)
        switch response {
        case .success(_, let model, let errorMessage):
            guard let userWasCreatedModel = model as? UserWasCreatedModel else {
                return .failure(errorMessage: "We are having problems right now... Please try later :(")
            }
            if userWasCreatedModel.userWasCreated {
                return .success
            } else {
                return .failure(errorMessage: errorMessage ?? "User was not created.")
            }
        case .failure(_,_,let errorMessage):
            return .failure(errorMessage: errorMessage ?? "User was not created.")
        }
        
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@st-andrews.ac.uk"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}


