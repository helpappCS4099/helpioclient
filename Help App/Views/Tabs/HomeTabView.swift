//
//  HomeTabView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 02/02/2023.
//

import SwiftUI
import MapKit

struct HomeTabView: View {
    
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
        if let location = clManager.location {
            region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            return region
        } else {
            return nil
        }
    }
    
    @State var showHelpRequestForm: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
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
                        print("help request")
                        showHelpRequestForm = true
                    } label: {
                        Text("Help Request")
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(width: bounds.width - 60)
                    }
                    .buttonStyle(LargeRedButton(hasShadow: true))
                    .padding()
                }
                .navigationTitle("Help Requests")
            }
            .sheet(isPresented: $showHelpRequestForm) {
                HelpRequestFormView(showHelpRequestForm: $showHelpRequestForm)
                    .interactiveDismissDisabled()
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
        HomeTabView()
    }
}
