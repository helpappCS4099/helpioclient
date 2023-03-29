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
    @State var showHelpRequestPrompt = false
    
    func pageVisitRoutine() async {
        //get user
        debugMessage = "fetching user"
        let (myUserObject, _) = await userInteractor.getMyself()
        if let user = myUserObject {
            appState.userID = user.userID
            debugMessage = "user received"
            queryHelpRequestStatusAndDisplay(user: user)
        }
        //focus on current location
        if let updatedRegion = getCurrentRegion() {
            withAnimation(.easeInOut) {
                region = updatedRegion
            }
        }
    }
    
    func queryHelpRequestStatusAndDisplay(user: UserModel) {
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
                            appState.showThumbnail = true
                        }
                    case 0:
                        //notified
                        debugMessage = "showing prompt"
                        withAnimation {
                            showHelpRequestPrompt = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                appState.showThumbnail = true
                            }
                        }
                    default:
                        //accepted / on the way
                        appState.showThumbnail = false
                    }
                }
            }
            SocketInteractor.standard.openSocket(for: user.respondingCurrentHelpRequestID)
        } else {
            SocketInteractor.standard.breakConnections()
            appState.showThumbnail = false
        }
    }
    
    func onUserChange(_ user: UserModel) {
        if user.respondingCurrentHelpRequestID != "" {
            queryHelpRequestStatusAndDisplay(user: user)
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
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
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
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    
    //                Text(debugMessage)
                    
                    Map(coordinateRegion: $region,
                        interactionModes: .all,
                        showsUserLocation: true,
                        userTrackingMode: $tracking)
                        .edgesIgnoringSafeArea(.all)
                        .scaleEffect(1.1)
                        .opacity(appState.showThumbnail ? 0.3 : 0.5)
                        .blur(radius: appState.showThumbnail ? 5 : 0)
                    
                    VStack {
                        
                        if appState.showThumbnail {
                            ThumbnailView(helpRequest: helpRequest, onTap: {
                                showHelpRequestPrompt = true
                            })
                                .frame(width: geometry.size.width - 32, height: geometry.size.height * 0.5)
                        }
                        
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
            }
        }
        .sheet(isPresented: $showHelpRequestForm) {
            HelpRequestFormView(
                showHelpRequestForm: $showHelpRequestForm,
                availableFriends: $availableFriends,
                onCreateHelpRequest: onCreateHelpRequest
            )
                .interactiveDismissDisabled(true)
        }
        .sheet(isPresented: $showHelpRequestPrompt, content: {
            PromptView(helpInteractor: helpInteractor, helpRequest: helpRequest, showHelpRequestPrompt: $showHelpRequestPrompt)
                .environmentObject(appState)
                .interactiveDismissDisabled(true)
        })
        .alert(errorMessage, isPresented: $showError) {
            Button("Hide", role: .cancel) {}
        }
        .task {
            await pageVisitRoutine()
        }
        .onChange(of: appState.user) { newValue in
            if let newUser = newValue {
                onUserChange(newUser)
            }
        }
        //workaround for reopened prompt
        .onChange(of: showHelpRequestPrompt, perform: { newValue in
            if appState.showHelpRequest && newValue == true {
                showHelpRequestPrompt = false
            }
        })
        .animation(.easeInOut, value: appState.showThumbnail)
    }
}

struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        let di = Environment.bootstrap().diContainer
        HomeTabView(helpInteractor: di.interactors.help, userInteractor: di.interactors.user)
            .environmentObject(di.appState)
    }
}
