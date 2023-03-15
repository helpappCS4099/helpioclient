//
//  HelpRequestFormView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 13/03/2023.
//

import SwiftUI

struct HelpRequestFormView: View {
    
    @Binding var showHelpRequestForm: Bool
    
    @State var progress: HelpRequestFormStage = .note
    @State var redButton: Bool = false
    
    @State var selectedCriticalSituation: CriticalSituation = .stalking
    
    var user: UserModel = UserModel(userID: "sjkldjsldjlsd",
                                   email: "ar303@st-andrews.ac.uk",
                                   firstName: "Artem",
                                   lastName: "Rakhmanov",
                                   verified: true,
                                   currentHelpRequestID: "",
                                   colorScheme: 2,
                                   friends: [
                                       FriendModel(userID: "jskldsjldjlsd",
                                                   firstName: "Bob",
                                                   lastName: "Roberts",
                                                   colorScheme: 1,
                                                   status: 1,
                                                   email: "br202@st-andrews.ac.uk")
                                   ])
    
    let criticalSituations = CriticalSituation.allCases
    
    let NOTESCROLLPOSITION: UUID = UUID()
    let BOTTOM: UUID = UUID()
    
    @FocusState var keyboardIsShown: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .leading) {
                    
                    ProgressBarView(progress: $progress)
                    
                    switch progress {
                    case .none:
                        EmptyView()
                    case .category:
                        CriticalSituationCategoryFormView()
                            .transition(.opacity)
                    default:
                        ScrollViewReader { scroll in
                            ScrollView(showsIndicators: false) {
                                VStack(spacing: 30) {
                                    FriendFormView(
                                        criticalSituation: $selectedCriticalSituation,
                                        user: user
                                    )
                                    
                                    if progress == .note {
                                        NoteFormView(keyboardIsShown: $keyboardIsShown)
                                            .id(NOTESCROLLPOSITION)
//                                            .adaptsToKeyboard()
                                            .onAppear {
                                                scroll.scrollTo(NOTESCROLLPOSITION)
                                            }
                                    }
                                    
                                    Spacer()
                                        .frame(height: 150)
                                    
                                    if keyboardIsShown {
                                        Spacer()
                                            .frame(height: 100)
                                            .id(BOTTOM)
                                    }
                                }
                                .onChange(of: keyboardIsShown) { newValue in
                                    if newValue {
                                        scroll.scrollTo(BOTTOM)
                                    }
                                }

                            }
                        }
                    }
                    
                    Spacer()
                }
                .navigationTitle(Text("Help Request"))
                .toolbar {
                    Button {
                        showHelpRequestForm = false
                    } label: {
                        Text("Cancel")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    hideKeyboard()
                }
                
                //overlay button
                if progress.rawValue > 1 {
                    VStack {
                        Spacer()
                        
                        Button {
                            //action
                        } label: {
                            Text(progress == .note ? "Get Help" : "Continue")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        .buttonStyle(FormAccessibleButton(isRed: $redButton))
                        .padding(.bottom)
                        .transition(.opacity)
                        .ignoresSafeArea(.keyboard)

                    }
                    .edgesIgnoringSafeArea(.bottom)
                }
            }
        }
        .onAppear {
//            progress = .category
            if progress == .note {
                redButton = true
            }
        }
    }
}

struct HelpRequestFormView_Previews: PreviewProvider {
    static var previews: some View {
        HelpRequestFormView(
            showHelpRequestForm: .constant(true),
            user: UserModel(userID: "sjkldjsldjlsd",
                            email: "ar303@st-andrews.ac.uk",
                            firstName: "Artem",
                            lastName: "Rakhmanov",
                            verified: true,
                            currentHelpRequestID: "",
                            colorScheme: 2,
                            friends: [
                                FriendModel(userID: "jskldsjldjlsd",
                                            firstName: "Bob",
                                            lastName: "Roberts",
                                            colorScheme: 1,
                                            status: 1,
                                            email: "br202@st-andrews.ac.uk")
                            ])
        )
        .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
    }
}
