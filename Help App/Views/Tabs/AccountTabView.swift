//
//  AccountTabView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 02/02/2023.
//

import SwiftUI

struct AccountTabView: View {
    
    var userInteractor: UserInteractor
    
    @State var firstName: String?
    @State var lastName: String?
    @State var email: String?
    @State var colorScheme: Int?
    
    let diameter: CGFloat = 150    //for circle
    
    @State var selectedColor: AccountGradient = .greenAsh
    
    @State var colorTappedID: Int?
    
    var onLogOut: () -> Void = {}
    
    func queryAndPopulateUser() {
        Task {
            let (user, _) = await userInteractor.getMyself()
            if let user {
                firstName = user.firstName
                lastName = user.lastName
                email = user.email
                colorScheme = user.colorScheme
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                
                ZStack {
                    HStack {
                        
                        VStack(alignment: .leading, spacing: 10) {
                            
                            Spacer()
                                .frame(height: 100)
                            
                            Text("\(firstName ?? "firstName") \(lastName ?? "lastName")")
                                .font(.title)
                                .fontWeight(.medium)
                            
                            Text(email ?? "somemail@djskdsl.com")
                                .font(.subheadline)
                                .fontWeight(.light)
                            
                            Spacer()
                        }
                        .padding()
                        
                        Spacer()
                    }
                    .background(selectedColor.gradient)
                    
                    VStack {
                        
                        HStack {
                            Spacer()
                            
                            Image("heartGraphicRing")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 75)
                                .padding()
                        }
                        
                        Spacer()
                    }
                }
                .listRowInsets(EdgeInsets())
                .if(firstName == nil) { config in
                    config.redacted(reason: .placeholder)
                }
                
//                Section(header: Text("Help Request History")) {
//                    Text("You have not yet had a help request.")
//                }
                
                Section(header: Text("Settings")) {
                    
                    centeredTextButton(text: "Permissions Settings", action: {
                        if let url = URL(string:UIApplication.openSettingsURLString) {
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }
                    })
                }
                
                Section {
                    centeredTextButton(text: "Log Out", isPlain: false, action: {
                        onLogOut()
                    })
                }
            
            }
            .refreshable {
                queryAndPopulateUser()
            }
        }
        .task {
            //get user
            queryAndPopulateUser()
        }
    }
    
    func accountColorSelection() -> some View {
        HStack {
            //circle
            ForEach(AccountGradient.allCases, id: \.id) { gradient in
                ZStack {
                    gradient.gradient
                        .mask(Circle())
                        .frame(height: 50)
                    
                    if selectedColor == gradient {
                        Circle()
                            .strokeBorder(Color.gray, lineWidth: 3)
                            .frame(height: 70)
                    }
                }
                .contentShape(Rectangle())
                .opacity(colorTappedID == gradient.id ? 0.5 : 1)
                .animation(.default, value: true)
                .onTapGesture {
                    colorTappedID = gradient.id
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        colorTappedID = nil
                        selectedColor = gradient
                    }
                }
            }
                
        }
    }
    
    func centeredTextButton(text: String, isPlain: Bool = true, action: @escaping () -> Void) -> some View {
        HStack {
            Spacer()
            
            Button(text) {
                action()
            }
            .foregroundColor(isPlain ? .adaptiveBlack : nil)
            
            Spacer()
        }
    }
}

struct AccountTabView_Previews: PreviewProvider {
    static var previews: some View {
        AccountTabView(userInteractor: Environment.bootstrapLoggedIn(currentPage: .friends).diContainer.interactors.user)
    }
}
