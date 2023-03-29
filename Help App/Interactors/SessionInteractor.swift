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
        async -> (Bool, Bool, OperationStatus)
    
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
        async -> (Bool, OperationStatus)
    
}

struct SessionInteractor {
    let appState: AppState
    let sessionWebRepository: SessionWebRepository
}

extension SessionInteractor {
    
    func logIn(email: String,
               password: String) async -> (Bool, Bool, OperationStatus) {
        //return: successfullyLoggedIn, isVerified, opStatus
        let loginResponse = await sessionWebRepository.logInRequest(email: email, password: password)
        switch loginResponse {
        case .success(_, let model, let errorMessage):
            guard let loginModel = model as? LoginUserModel else {
                print("error at model casting in logIN interactor call")
                return (false, false, .failure(errorMessage: errorMessage ?? "We are having a trouble logging you in now... Please try again later"))
            }
            if !loginModel.authenticated {
                return (false, false, .failure(errorMessage: "Please enter correct credentials to your account."))
            }
            print(loginModel)
            //save jwt to secureenclave
            if let jwt = loginModel.jwt {
                KeychainHelper.standard.save(jwt: jwt, service: "jwt", account: "helpapp")
            }
            
            //force unwrap because is authenticated
            if loginModel.user!.verified {
                return (true, true, .success)
            } else {
                return (true, false, .success)
            }
        case .failure(_, _, let errorMessage):
            return (false, false, .failure(errorMessage: errorMessage ?? "We are having a trouble logging you in now... Please try again later"))
        }
    }
    
    func logOut() async -> OperationStatus {
        let response = await sessionWebRepository.logOutRequest()
        if response.status == 200 {
            //reset user defaults
            appState.showHelpRequest = false
            appState.helpRequestID = ""
            appState.userID = ""
            appState.showThumbnail = false
            appState.isRespondent = false
            //reset auth screen
            appState.auth = AuthState()
            appState.userIsLoggedIn = false
            UserDefaults.standard.set(false, forKey: "isLogged")
            appState.currentPage = .home
            return .success
        } else {
            return .failure(errorMessage: "Couldn't log you out. Please try again later.")
        }
    }
    
    func updateAPNToken(deviceToken: String) async -> OperationStatus {
        let tokenUpdateReponse = await sessionWebRepository.updateAPNTokenRequest(deviceToken: deviceToken)
        switch tokenUpdateReponse {
        case .success(_,_,_):
            return .success
        case .failure(_, _, let errorMessage):
            print(errorMessage ?? "error at updateToken.failure switch (interactor)")
            return .failure(errorMessage: errorMessage ?? "Token could not be updated")
        }
    }
    
    func checkEmailVerification() async -> (Bool, OperationStatus) {
        let verificationResponse = await sessionWebRepository.checkEmailVerificationRequest()
        switch verificationResponse {
        case .success(_, let model, _):
            guard let verificationModel = model as? EmailVerificationModel else {
                return (false, .failure(errorMessage: "Investigate Internal Error @ checkEmailVerification"))
            }
            print(verificationModel)
            if verificationModel.userIsVerified {
                //save JWT, safe to assume presence of jwt if verified
                KeychainHelper().save(jwt: verificationModel.jwt!, service: "jwt", account: "helpapp")
                return (true, .success)
            } else {
                return (false, .success)
            }
        case .failure(_, _, let errorMessage):
            return (false, .failure(errorMessage: errorMessage ?? "We are having a problem right now...Please try again later"))
        }
    }
    
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
            print(errorMessage ?? "no error message")
            return .failure(errorMessage: errorMessage ?? "User was not created.")
        }
        
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@st-andrews.ac.uk"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}


