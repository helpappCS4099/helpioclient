//
//  HelpRequestFormView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 13/03/2023.
//

import SwiftUI

struct HelpRequestFormView: View {
    
    @Binding var showHelpRequestForm: Bool
    @Binding var availableFriends: [FriendModel]
    @State var selectedFriendIDS: [String] = []
    @State var messages: [String] = []
    
    @State var progress: HelpRequestFormStage = .none
    @State var redButton: Bool = false
    
    @State var selectedCriticalSituation: CriticalSituation = .trauma
    
    let criticalSituations = CriticalSituation.allCases
    
    let NOTESCROLLPOSITION: UUID = UUID()
    let BOTTOM: UUID = UUID()
    
    @FocusState var keyboardIsShown: Bool
    
    @State var errorMessage: String = ""
    @State var showError = false
    
    var onCreateHelpRequest: (Int, [FriendModel], [String], [String]) -> Void = {_,_,_,_ in
        
    }
    
    var audioRecorder: AudioRecorder = AudioRecorder(session: Date().toString(dateFormat: "dd-MM-YY__HH_mm_ss"))
    
    func onSituationSelect(_ situation: CriticalSituation) {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        selectedCriticalSituation = situation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            progress = .friends
        }
    }
    
    func onFriendsSelect() {
        if selectedFriendIDS.isEmpty {
            //illegal
            errorMessage = "You need to select at least one friend"
            showError = true
            return
        }
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        progress = .note
    }
    
    func createHelpRequest() {
        let impact = UIImpactFeedbackGenerator(style: .heavy)
        impact.impactOccurred()
        if selectedFriendIDS.isEmpty {
            //illegal
            errorMessage = "You need to select at least one friend"
            showError = true
            return
        }
        onCreateHelpRequest(selectedCriticalSituation.categoryCode, availableFriends, selectedFriendIDS, messages)
    }
    
    func onRecordingEnd() {
        //fetch the new audio recording
        //add new audio message to messages array
    }
    
    func onAddMessage(_ messageBody: String) {
        //add new text message to messages array
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                VStack(alignment: .leading) {
                    
                    ProgressBarView(progress: $progress)
                    
                    switch progress {
                    case .none:
                        EmptyView()
                    case .category:
                        CriticalSituationCategoryFormView(
                            selectedCriticalSituation: $selectedCriticalSituation,
                            onSelect: onSituationSelect
                        )
                        .transition(.opacity)
                    default:
                        ScrollViewReader { scroll in
                            ScrollView(showsIndicators: false) {
                                VStack(spacing: 30) {
                                    FriendFormView(
                                        criticalSituation: $selectedCriticalSituation,
                                        friends: $availableFriends,
                                        onBackToCategory: {
                                            progress = .category
                                        },
                                        selectedFriends: $selectedFriendIDS
                                    )
                                    
                                    if progress == .note {
                                        NoteFormView(
                                            messages: $messages,
                                            keyboardIsShown: $keyboardIsShown,
                                            audioRecorder: audioRecorder,
                                            onMessageSend: {
                                                scroll.scrollTo(NOTESCROLLPOSITION)
                                            }
                                        )
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
                            .scrollDisabled(keyboardIsShown)
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
                .alert(errorMessage, isPresented: $showError) {
                    Button("Hide", role: .cancel) {}
                }
                .onChange(of: progress) { newValue in
                    if newValue.rawValue > 2 {
                        redButton = true
                    } else {
                        redButton = false
                    }
                }
                
                //overlay button
                if progress.rawValue > 1 {
                    VStack {
                        Spacer()
                        
                        Button {
                            //friends -> note -> create
                            switch progress {
                            case .friends:
                                onFriendsSelect()
                            case .note:
                                createHelpRequest()
                            default:
                                break
                            }
                        } label: {
                            Text(progress == .note ? "Get Help" : "Continue")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        .buttonStyle(FormAccessibleButton(isRed: $redButton))
                        .padding(.bottom, 5)
                        .transition(.opacity)
                        .animation(.default, value: progress)
                        .ignoresSafeArea(.keyboard)
                        
                    }
                    .edgesIgnoringSafeArea(.bottom)
                }
            }
        }
        .onAppear {
            progress = .category
        }
    }
}

struct HelpRequestFormView_Previews: PreviewProvider {
    static var previews: some View {
        HelpRequestFormView(
            showHelpRequestForm: .constant(true),
            availableFriends: .constant([])
        )
        .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
    }
}
