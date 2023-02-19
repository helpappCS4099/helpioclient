//
//  SignInView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 16/02/2023.
//

import SwiftUI

struct SignInFieldsView: View {
    
    @Binding var email: String
    @Binding var password: String
    
    var focusedField: FocusState<FocusedField?>.Binding
    
    var login_onEmailCommit: () -> Void
    var login_onPasswordCommit: () -> Void
    
    var body: some View {
        VStack(spacing: 10) {

            Field(fieldLabel: "Enter your university email",
                  placeholder: "@st-andrews.ac.uk",
                  text: $email,
                  commit: login_onEmailCommit,
                  fieldType: .email,
                  focusedField: focusedField,
                  type: .emailAddress)

            Field(fieldLabel: "Enter your passowrd",
                  placeholder: "Password1234",
                  text: $password,
                  commit: {},
                  fieldType: .password,
                  focusedField: focusedField,
                  type: .password)
        }
    }
    
}

extension AuthRootView {
    
    // MARK: - Logic
    
    //email commit
    func login_onEmailCommit() {
        
        let isValid = sessionInteractor.isValidEmail(email: email)
        
        if !isValid {
            errorMessage = "Please enter a valid St Andrews email."
            focusedField = .email
            return
        }
        
        errorMessage = nil
        
        focusedField = .password
    }
}
