//
//  ThumbnailView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 27/03/2023.
//

import SwiftUI
import MapKit

struct ThumbnailView: View {
    
    @StateObject var helpRequest: HelpRequestState
    
    var onTap: () -> Void = {}
    
    @State var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 56.340024,
            longitude: -2.797745),
        span: MKCoordinateSpan(
            latitudeDelta: 0.03,
            longitudeDelta: 0.03)
        )
    
    func getCurrentRegion() -> MKCoordinateRegion? {
        if let location = LocationTracker.standard.cl.location {
            withAnimation {
                region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            }
            return region
        } else {
            return nil
        }
    }
    
    @State var tracking : MapUserTrackingMode = .follow
    @Binding var ownerAnnotation: [AnnotationItem]
    @Binding var distance: String
    
    @State var tapped: Bool = false
    
    func updateAnnotation() {
        ownerAnnotation = helpRequest.getOwnerMapItem()
        if let a = ownerAnnotation.last {
            region = MKCoordinateRegion(
                center: a.coordinate,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.01,
                    longitudeDelta: 0.01)
            )
            distance = a.getDistanceToUser()
        }
    }
    
    @State var minutes: Int = 0
    @State var seconds: Int = 0
    @State var stopwatchString: String = ""
    @State var timer: Timer?
    
    func startStopwatch() {
        if let startIsoDate = helpRequest.startTime {
            stopStopwatch()
            (self.minutes, self.seconds) = Date.getTimerStartingPoint(isoDate: startIsoDate)
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { t in
                (self.minutes, self.seconds) = Date.addSecond(toMinutes: minutes, toSeconds: seconds)
                stopwatchString = getStopwatchString()
            }
        }
    }
    
    func stopStopwatch() {
        self.timer?.invalidate()
    }
    
    func getStopwatchString() -> String {
        
        let minutes = minutes.size == 1 ? String("0\(minutes)") : String(minutes)
        let seconds = seconds.size == 1 ? String("0\(seconds)") : String(seconds)
        
        return minutes + ":" + seconds
    }
    
    var body: some View {
        ZStack {
            //map
            Map(coordinateRegion: $region,
                interactionModes: .all,
                showsUserLocation: true,
                userTrackingMode: $tracking,
                annotationItems: ownerAnnotation,
                annotationContent: { locationPoint in
                    MapAnnotation(coordinate: locationPoint.coordinate, anchorPoint: CGPoint(x:0.5, y:1.0)) {
                        UserLocationPin(locationPoint: locationPoint, region: $region, distance: $distance, showDistanceMessage: .constant(false), owner: helpRequest.owner != nil ? $helpRequest.owner : .constant(OwnerModel(userID: "", firstName: "", lastName: "", colorScheme: 1)))
                    }
                }
            )
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    startStopwatch()
                    if let _ = ownerAnnotation.last {
                        updateAnnotation()
                    }
                }
                .onDisappear {
                    stopStopwatch()
                }
            
            VStack {
                stopwatch
                    .padding(.top)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                //highlights row
                HStack {
                    HStack(spacing: 10) {
                        CriticalSituation(code: helpRequest.category ?? 0).image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                        
                        Text(CriticalSituation(code: helpRequest.category ?? 0).rawValue)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .lineLimit(2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(maxWidth: .infinity)
                    
                    HStack {
                        Image(systemName: "message.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        
                        Text(String(helpRequest.messages.count))
                    }
                    .frame(width: 40, height: 40)
                    .padding([.leading, .trailing])
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    HStack {
                        Text(distance)
                    }
                    .frame(height: 40)
                    .padding([.leading, .trailing])
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(10)
                .frame(height: 50)
                
                Spacer().frame(height: 20)
                
                //bottom message sheet
                HStack {
                    ZStack {
                        Text((helpRequest.owner?.firstName[0].uppercased() ?? "A") + (helpRequest.owner?.lastName[0].uppercased() ?? "B"))
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.3), radius: 5)
                    }
                    .frame(width: 60, height: 60)
                    .background(AccountGradient.getByID(id: helpRequest.owner?.colorScheme ?? 1))
                    .clipShape(Circle())
                    
                    VStack {
                        HStack(spacing: 0) {
                            Text(helpRequest.owner?.firstName ?? "Name")
                                .fontWeight(.bold)
                            Text(" is calling for your help.")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Text("Please respond.")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Spacer()
                }
                .padding(10)
                .background(.ultraThinMaterial)
                .frame(maxWidth: .infinity)
                .frame(height: 70, alignment: .center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
        .opacity(tapped ? 0.7 : 1)
        .scaleEffect(tapped ? 0.95: 1)
        .animation(.spring(), value: tapped)
        .contentShape(Rectangle())
        .overlay(content: {
            if helpRequest.owner == nil {
                ProgressView()
                    .onDisappear {
                        startStopwatch()
                    }
            }
        })
        .onChange(of: ownerAnnotation, perform: { newValue in
            updateAnnotation()
            startStopwatch()
        })
        .onTapGesture {
            tapped = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                tapped = false
                onTap()
            }
        }
        .if(helpRequest.owner == nil) { config in
            config.redacted(reason: .placeholder)
        }
    }
    
    private var stopwatch: some View {
        VStack(alignment: .trailing) {
            
            ZStack {
                Text(stopwatchString)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                    .padding()
            }
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.trailing)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

struct ThumbnailView_Previews: PreviewProvider {
    static var previews: some View {
        ThumbnailView(helpRequest: HelpRequestState(), ownerAnnotation: .constant([]), distance: .constant("500m"))
            .frame(width: bounds.width - 32, height: 400)
    }
}
