//
//  SignUpView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 16/02/2023.
//

import SwiftUI

struct SignUpCredentialFieldsView: View {
    
    @Binding var email: String
    @Binding var password: String
    
    var focusedField: FocusState<FocusedField?>.Binding
    
    var signup_onEmailCommit: () -> Void
    var signup_onPasswordCommit: () -> Void
    
    var body: some View {
        
        VStack(spacing: 10) {

            Field(fieldLabel: "Your university email",
                  placeholder: "@st-andrews.ac.uk",
                  text: $email,
                  commit: signup_onEmailCommit,
                  fieldType: .email,
                  focusedField: focusedField,
                  type: .emailAddress)
                    .keyboardType(.emailAddress)

            Field(fieldLabel: "Come up with a password",
                  placeholder: "Password1234",
                  text: $password,
                  commit: signup_onPasswordCommit,
                  fieldType: .password,
                  focusedField: focusedField,
                  type: .password)
        }
    }
}

struct SignUpNameFieldsView: View {
    
    @Binding var firstName: String
    @Binding var lastName: String
    
    var focusedField: FocusState<FocusedField?>.Binding
    
    var signup_onFirstNameCommit: () -> Void
    var signup_onLastNameCommit: () -> Void
    
    var body: some View {
        VStack(spacing: 10) {

            Field(fieldLabel: "First name",
                  placeholder: "",
                  text: $firstName,
                  commit: signup_onFirstNameCommit,
                  fieldType: .firstName,
                  focusedField: focusedField,
                  type: .givenName)

            Field(fieldLabel: "Last name",
                  placeholder: "",
                  text: $lastName,
                  commit: signup_onLastNameCommit,
                  fieldType: .lastName,
                  focusedField: focusedField,
                  type: .familyName)
        }
    }
}

extension AuthRootView {
    // MARK: - Logic
    
    //email commit
    func signup_onEmailCommit() {
        let isValid = sessionInteractor.isValidEmail(email: email)
        
        if !isValid {
            errorMessage = "Please enter a valid St Andrews email."
            focusedField = .email
            return
        }
        
        errorMessage = nil
        
        focusedField = .password
    }
    
    func signup_onPasswordCommit() {
        //check password is non empty
        if (password.isEmpty) {
            errorMessage = "Please come up with a password"
            focusedField = .password
            return
        }
        focusedField = .none
        onPrimaryButtonTap()
    }
    
    func signup_onFirstNameCommit() {
        if (firstName.isEmpty) {
            errorMessage = "Please enter your first name"
            focusedField = .firstName
            return
        }
        errorMessage = nil
        focusedField = .lastName
    }
    
    func signup_onLastNameCommit() {
        if (lastName.isEmpty) {
            errorMessage = "Please enter your last name"
            focusedField = .lastName
            return
        }
        errorMessage = nil
        onPrimaryButtonTap()
    }
}
