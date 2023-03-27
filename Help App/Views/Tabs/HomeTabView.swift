//
//  HomeTabView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 02/02/2023.
//

import SwiftUI
import MapKit

struct HomeTabView: View {
    
    @EnvironmentObject var appState: AppState
    
    var helpInteractor: HelpInteractor
    var userInteractor: UserInteractor
    
    @State var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 40.83834587046632,
            longitude: 14.254053016537693),
        span: MKCoordinateSpan(
            latitudeDelta: 0.03,
            longitudeDelta: 0.03)
        )
    
    @State var tracking : MapUserTrackingMode = .follow
    
    func getCurrentRegion() -> MKCoordinateRegion? {
        if let location = LocationTracker.standard.cl.location {
            region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            return region
        } else {
            return nil
        }
    }
    
    @State var showHelpRequestForm: Bool = false
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    
    @State var debugMessage: String = ""
    
    @State var availableFriends: [FriendModel] = []
    
    @State var isLoading: Bool = false
    
    @StateObject var helpRequest: HelpRequestState = HelpRequestState(id: "")
    @State var showHelpRequestThumbnail = false
    @State var showHelpRequestPrompt = false
    
    func pageVisitRoutine() async {
        //get user
        debugMessage = "fetching user"
        let (myUserObject, _) = await userInteractor.getMyself()
        if let user = myUserObject {
            appState.userID = user.userID
            debugMessage = "user received"
            if user.respondingCurrentHelpRequestID != "" {
                debugMessage = "user is responding to help request"
                helpRequest.helpRequestID = user.respondingCurrentHelpRequestID
                //open socket connection
                SocketInteractor.standard.onUpdate = { update in
                    helpRequest.updateFields(model: update)
                    if let respondent = update.respondents.first(where: {$0.userID == appState.userID}) {
                        switch respondent.status {
                        case -1:
                            //rejected
                            debugMessage = "showing thumbnail"
                            withAnimation(.easeInOut) {
                                showHelpRequestThumbnail = true
                            }
                        case 0:
                            //notified
                            debugMessage = "showing prompt"
                            withAnimation {
                                showHelpRequestPrompt = true
                            }
                        default:
                            //accepted / on the way
                            break
                        }
                    }
                }
                SocketInteractor.standard.openSocket(for: user.respondingCurrentHelpRequestID)
            } else {
                SocketInteractor.standard.breakConnections()
            }
        }
        //focus on current location
        if let updatedRegion = getCurrentRegion() {
            withAnimation(.easeInOut) {
                region = updatedRegion
            }
        }
    }
    
    func onCreateHelpRequest(category: Int, friends: [FriendModel], selectedFriends: [String], messages: [String]) {
        Task {
            print("creating...")
            let (model, opStatus) = await helpInteractor.createNewHelpRequest(
                category: category,
                messages: messages,
                selectedFriendIDs: selectedFriends,
                friends: friends
            )
            
            print(model, opStatus)
        }
    }
    
    func onAddHelpRequestTap() {
        Task {
            let impact = await UIImpactFeedbackGenerator(style: .light)
            await impact.impactOccurred()
            isLoading = true
            //fetch available friends
            let (friends, opStatus) = await helpInteractor.getAvailableFriends()
            isLoading = false
            //if exists - open
            availableFriends = friends
            if (availableFriends.isEmpty) {
                errorMessage = "All of your friends are currently unavailble, as they are helping someone. Please try again later."
                showError = true
                return
            }
            if (opStatus == .success) {
                showHelpRequestForm = true
                return
            }
            //if not show alert
            errorMessage = opStatus.errorMessage
            showError = true
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                Text(debugMessage)
                
                Map(coordinateRegion: $region,
                    interactionModes: .all,
                    showsUserLocation: true,
                    userTrackingMode: $tracking)
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
                    .opacity(0.5)
                
                VStack {
                    Spacer()
                    
                    
                    Button {
                        onAddHelpRequestTap()
                    } label: {
                        Text(isLoading ? "" : "Help Request")
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(width: bounds.width - 60)
                    }
                    .buttonStyle(LargeRedButton(hasShadow: true))
                    .overlay {
                        //progress indicator
                        if isLoading {
                            ProgressView()
                                .scaleEffect(1.5)
                                
                        }
                    }
                    .padding()
                }
                .navigationTitle("Help Requests")
            }
            .sheet(isPresented: $showHelpRequestForm) {
                HelpRequestFormView(
                    showHelpRequestForm: $showHelpRequestForm,
                    availableFriends: $availableFriends,
                    onCreateHelpRequest: onCreateHelpRequest
                )
                    .interactiveDismissDisabled()
            }
            .sheet(isPresented: $showHelpRequestPrompt, content: {
                PromptView(helpInteractor: helpInteractor, helpRequest: helpRequest, showHelpRequestPrompt: $showHelpRequestPrompt)
                    .interactiveDismissDisabled(true)
            })
            .alert(errorMessage, isPresented: $showError) {
                Button("Hide", role: .cancel) {}
            }
        }
        .task {
            await pageVisitRoutine()
        }
    }
}

struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        let di = Environment.bootstrap().diContainer
        HomeTabView(helpInteractor: di.interactors.help, userInteractor: di.interactors.user)
            .environmentObject(di.appState)
    }
}
