//
//  AuthRootView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 02/02/2023.
//

import SwiftUI

// MARK: - local data, root layout and UI operations
struct AuthRootView: View {
    
    @EnvironmentObject var authState: AuthState
    var sessionInteractor: SessionInteractor
    
    @State var isLoading: Bool = false
    
    @FocusState var focusedField: FocusedField?
    
    @State var email: String = ""
    @State var password: String = ""
    @State var firstName: String = ""
    @State var lastName: String = ""
    
    @State var errorMessage: String? = nil
    
    var body: some View {
        GeometryReader { _ in
            VStack {
                header()
                    .padding(.top)
                
                if errorMessage != nil {
                    
                    errorMessageScreen()
                        .padding(.top, 6)
                        .animation(.easeInOut(duration: 0.2))
                }
                
                Spacer()
                
                ZStack {
                    switch authState.currentScreen {
                    case .landing:
                        EmptyView()
                    case .login:
//                        signInFields()
                        SignInFieldsView(email: $email,
                                         password: $password,
                                         focusedField: $focusedField,
                                         login_onEmailCommit: login_onEmailCommit,
                                         login_onPasswordCommit: {})
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    focusedField = .email
                                }
                            }
                    case .signup_credentials:
                        SignUpCredentialFieldsView(email: $email,
                                         password: $password,
                                         focusedField: $focusedField,
                                         signup_onEmailCommit: login_onEmailCommit,
                                         signup_onPasswordCommit: {})
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    focusedField = .email
                                }
                            }
                    case .signup_name:
                        SignUpNameFieldsView(firstName: $firstName,
                                             lastName: $lastName,
                                             focusedField: $focusedField,
                                             signup_onFirstNameCommit: signup_onFirstNameCommit,
                                             signup_onLastNameCommit: signup_onLastNameCommit)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    focusedField = .firstName
                                }
                            }
                    case .verification:
                        verifyEmail()
                    case .persmissions:
                        grantPermissions()
                    }
                }
                .animation(.easeInOut(duration: 0.2))
                
                Spacer()
                
                bottomButtonContainer()
                    .padding(.bottom, 29)
                    .animation(.easeInOut(duration: 0.2))
            }
            .contentShape(Rectangle())
            .onTapGesture {
                focusedField = nil
            }
            .animation(.none)
            .opacity(isLoading ? 0.5 : 1)
            .scaleEffect(isLoading ? 0.99 : 1)
            .overlay {
                //loading indicator
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        
                }
            }
            .animation(.easeInOut(duration: 0.2))
        }
    }
    
    
    
}

// MARK: - logic
extension AuthRootView {
    //if user taps on primary button
    func onPrimaryButtonTap() {
        //routes navigation / actions based on event origin screen
        switch authState.currentScreen {
        case .landing:
            authState.currentScreen = .login
            break
        case .login:
            //login operation
            break
        case .signup_credentials:
            Task {
                isLoading = true
                //check email
                let (isValid, operationStatus) = await sessionInteractor.checkEmail(email: email)
                
                isLoading = false
                
                if operationStatus != OperationStatus.success {
                    errorMessage = operationStatus.errorMessage
                    focusedField = .email
                    return
                }
                
                if !isValid {
                    errorMessage = "This email cannot be used for a new account."
                    focusedField = .email
                    return
                }
                
                //fields not empty
                if (password.isEmpty) {
                    errorMessage = "Please come up with a password"
                    focusedField = .password
                    return
                }
                
                errorMessage = nil
                
                authState.currentScreen = .signup_name
            }
            break
        case .signup_name:
            //check all fields non empty
            if (firstName.isEmpty && lastName.isEmpty) {
                errorMessage = "Please enter your first name and surname"
                return
            }
            Task {
                isLoading = true
                //perform user creation
                let operation = await sessionInteractor.createNewUser(email: email,
                                                                      password: password,
                                                                      firstName: firstName,
                                                                      lastName: lastName)
                
                if operation != .success {
                    errorMessage = operation.errorMessage
                    return
                }
                
                isLoading = false
                
                //move to verification
                authState.currentScreen = .verification
            }
            break
        case .verification:
            //query verification status
            //if verified, go to permissions
            break
        case .persmissions:
            //system ask for permissions
            //get APN token
            break
        }
    }
    
    //if user taps on tertiary button
    func onTertiaryButtonTap() {
        //routes navigation / actions based on event origin screen
        switch authState.currentScreen {
        case .landing:
            authState.currentScreen = .signup_credentials
            break
        case .login:
            //clear fields
            authState.currentScreen = .signup_credentials
            break
        case .signup_credentials:
            //clear fields
            authState.currentScreen = .login
            break
        case .signup_name:
            //back to credentials
            authState.currentScreen = .signup_credentials
            break
        case .verification:
            //query verification status
            //if verified, go to permissions
            break
        case .persmissions:
            //system ask for permissions
            //get APN token
            break
        }
    }
    
    
}

// MARK: - components
extension AuthRootView {
    
    func header() -> some View {
        VStack(alignment: .center ,spacing: 10) {
            if (authState.currentScreen != .verification &&
                authState.currentScreen != .persmissions) {
                //icon
                Image("staIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 60)
            }
            
            Text(authState.currentScreen.headerTitle)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            if (authState.currentScreen == .verification) {
                Text(authState.currentScreen.headerSubtitle)
                    .font(.title3)
            }
            
        }
    }
    
    func errorMessageScreen() -> some View {
        ZStack {
            if errorMessage != nil {
                Text(errorMessage ?? "")
                    .font(.body)
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.red)
                    .frame(width: bounds.width * 0.7)
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                EmptyView()
            }
        }
    }
    
    func bottomButtonContainer() -> some View {
        VStack(alignment: .center ,spacing: 29) {
        
            Button {
                onPrimaryButtonTap()
            } label: {
                Text(authState.currentScreen.primaryButtonLabel)
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(width: bounds.width - 60)
            }
            .buttonStyle(SystemLargeButton())
            
            //dumb conditional due to constant bugs with .ignoresSafeArea and keyboard avoidance...
            if (focusedField != .password &&
                focusedField != .email &&
                focusedField != .firstName &&
                focusedField != .lastName) {
                Button {
                    onTertiaryButtonTap()
                } label: {
                    Text(authState.currentScreen.secondaryButtonLabel)
                        .font(.title2)
                        .frame(width: bounds.width - 60)
                }
                .foregroundColor(Color.tertblue)
            }
        }
        .frame(width: bounds.width)
    }
}

extension AuthRootView {
//    func customField(fieldLabel: string) -> some View {
//
//    }
}

struct AuthRootView_Previews: PreviewProvider {
    static var previews: some View {
        AuthRootView(sessionInteractor: Environment.bootstrap().diContainer.interactors.sessionInteractor)
            .environmentObject(AppState.bootstrap().auth)
    }
}
