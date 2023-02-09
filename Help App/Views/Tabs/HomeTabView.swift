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
    
    var body: some View {
        NavigationView {
            ZStack {
                Map(coordinateRegion: $region, interactionModes: [])
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
                    .blur(radius: 6)
                    .opacity(0.5)
                
                VStack {
                    Spacer()
                    
                    
                    Button {
                        print("help request")
                    } label: {
                        Text("Help Request")
                            .frame(width: bounds.width - 60)
                    }
                    .buttonStyle(LargeRedButton())
                    .padding()
                }
                .navigationTitle("Help Requests")
            }
        }
    }
}

struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView()
    }
}
