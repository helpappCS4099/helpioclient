//
//  HomeTabView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 02/02/2023.
//

import SwiftUI
import MapKit

struct HomeTabView: View {
    
    var helpInteractor: HelpInteractor
    
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
                
//                Text(debugMessage)
                
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
            .alert(errorMessage, isPresented: $showError) {
                Button("Hide", role: .cancel) {}
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if let updatedRegion = getCurrentRegion() {
                    region = updatedRegion
                }
            }
        }
    }
}

struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        let di = Environment.bootstrap().diContainer
        HomeTabView(helpInteractor: di.interactors.help)
    }
}
