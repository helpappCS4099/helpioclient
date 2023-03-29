//
//  RespondentHelpRequestView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 24/03/2023.
//

import SwiftUI
import MapKit

struct RespondentHelpRequestView: View {
    
    @EnvironmentObject var appState: AppState
    
    var helpInteractor: HelpInteractor
    
    @StateObject var helpRequest: HelpRequestState
    
    //map states
    @State var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 56.340876,
            longitude: -2.800757),
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
    @State var annotations: [AnnotationItem] = []
    @State var distanceToOwner: String = ""
    
    //page states
    @State var detent: PresentationDetent = .fraction(0.45)
    @State var showContent: Bool = false
    @State var showCloseMessage: Bool = false
    @State var showRejectDialogue: Bool = false
    @SwiftUI.Environment(\.colorScheme) var colorScheme : ColorScheme
    
    //other
    
    func showSheet() {
        RunLoop.main.schedule {
            showContent = true
        }
    }
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region,
                interactionModes: .all,
                showsUserLocation: true,
                userTrackingMode: $tracking,
                annotationItems: annotations,
                annotationContent: { coordinatePoint in
                MapAnnotation(coordinate: coordinatePoint.coordinate) {
                    UserLocationPin(
                        locationPoint: coordinatePoint,
                        region: $region,
                        distance: $distanceToOwner,
                        showDistanceMessage: .constant(false),
                        victimView: false,
                        isOwner: coordinatePoint.userID == helpRequest.owner?.userID
                    )
                }
            }
            )
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    detent = .fraction(0.45)
                    showContent = true
                    startStopwatch()
                }
            
            
            topRightCornerButtons
            
            stopwatch
            
        }
        .transparentSheet(show: $showContent) {
            //ondismiss
        } content: {
            RespondentHRContentView(helpInteractor: helpInteractor, detent: $detent, distance: $distanceToOwner, onUpdateLocation: {
                let ownerRegion = helpRequest.getOwnerMapItem()
                withAnimation {
                    region = ownerRegion.getMKMapRectRegion()
                    distanceToOwner = ownerRegion.getDistanceToUser()
                }
                
            })
                .environmentObject(helpRequest)
                .presentationDetents(
                    undimmed: [.fraction(0.25), .fraction(0.45), .fraction(0.97), .fraction(1)],
                    largestUndimmed: .fraction(1),
                    selection: $detent
                )
                .interactiveDismissDisabled(true)
                .background(Color.white.opacity(colorScheme == .light ? 0.5 : 0))
                .if(helpRequest.owner == nil) { config in
                    config.redacted(reason: .placeholder)
                }
                .confirmationDialog("Close help request?",
                                    isPresented: $showRejectDialogue) {
                    Button("Reject help request", role: .destructive) {
                        helpInteractor.rejectHelpRequest(firstName: helpRequest.myName())
                        appState.showHelpRequest = false
                    }
                    Button("Cancel", role: .cancel) {
                        DispatchQueue.main.async {
                            showRejectDialogue = false
                            showContent = true
                        }
                    }
                }
        }
        .onAppear {
            showSheet()
            print("SHEET", showContent)
        }
        .onDisappear {
            stopStopwatch()
        }
        .task {
            print("onappear")
            #if !targetEnvironment(simulator)
            startStopwatch()
            annotations = helpRequest.getAllMapItemsWithoutMe()
            distanceToOwner = helpRequest.getOwnerMapItem().getDistanceToUser()
            _ = getCurrentRegion()
            guard let id = UserDefaults.standard.string(forKey: "helpRequestID") else {
                print("user defauls sucks")
                return
            }
            SocketInteractor.standard.onUpdate = { updatedModel in
                helpRequest.updateFields(model: updatedModel)
                annotations = helpRequest.getAllMapItemsWithoutMe()
                distanceToOwner = helpRequest.getOwnerMapItem().getDistanceToUser()
                startStopwatch()
            }
            SocketInteractor.standard.onClose = {
                helpInteractor.closeOnResolutionHelpRequest()
            }
            if helpRequest.helpRequestID != nil && helpRequest.helpRequestID != "" {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    SocketInteractor.standard.openSocket(for: helpRequest.helpRequestID!)
                    LocationTracker.standard.startMonitoringLocation()
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    SocketInteractor.standard.openSocket(for: id)
                    helpRequest.helpRequestID = id
                    LocationTracker.standard.startMonitoringLocation()
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                showSheet()
                detent = .fraction(0.45)
            }
            #else
            annotations = helpRequest.getAllMapItemsWithoutMe()
            distanceToOwner = helpRequest.getOwnerMapItem().getDistanceToUser()
            #endif
        }
    }
    
    private var topRightCornerButtons: some View {
        VStack(alignment: .trailing) {
            //button stack
            VStack(alignment: .center, spacing: 0) {
                Button {
                    //resolve HR
                    DispatchQueue.main.async {
                        showRejectDialogue = true
                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 28, weight: .light))
                        .tint(colorScheme == .light ? .gray : .white)
                }
                .padding(8)
                .frame(height: 55)
                
                Divider()
                
                Button {
                    //focus on current location
                    _ = getCurrentRegion()
                } label: {
                    Image(systemName: "location.fill")
                        .font(.system(size: 28, weight: .light))
                        .tint(colorScheme == .light ? .gray : .white)
                }
                .padding(8)
                .frame(height: 55)

            }
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 7))
            .frame(width: 50)
            .frame(maxHeight: 120)
            .padding(.trailing)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
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
            .padding(.leading)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct RespondentHRContentView: View {
    
    @EnvironmentObject var helpRequest: HelpRequestState
    
    var helpInteractor: HelpInteractor
    
    @Binding var detent: PresentationDetent
    @Binding var distance: String
    var onUpdateLocation: () -> Void = {}
    
    @State var showMessages: Bool = false
    @State var focused = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                if !showMessages {
                    Group {
                        //status row
                        HStack {
                            HStack(spacing: 10) {
                                CriticalSituation(code: helpRequest.category ?? 0).image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                
                                VStack(spacing: 6) {
                                    Text(CriticalSituation(code: helpRequest.category ?? 0).rawValue)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .lineLimit(1)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text(helpRequest.currentStatus?.progressMessageRespondent ?? "Progress Message Placeholder")
                                        .font(.footnote)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.leading)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Button {
                                onUpdateLocation()
                            } label: {
                                Text(distance)
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.large)

                        }
                        .padding()
                        
                        //self
                        if helpRequest.respondents.count > 0 {
                            GeometryReader { g in
                                MyStatusView(geometry: g, onOnTheWay: {
                                    //on the way
                                    SocketInteractor.standard.sendOnTheWayStatus(userID: helpRequest.myUserID, firstName: helpRequest.myName())
                                }, onTap: {
                                    //on tap
                                })
                                .environmentObject(helpRequest)
                                .frame(height: g.size.height - 32)
                                .frame(maxHeight: 100)
                                .padding([.leading, .trailing])
                                .padding([.top, .bottom], 10)
                            }
                            .frame(height: 100)
                        }
                        
                        //message preview
                        GeometryReader { g in
                            if !helpRequest.messages.isEmpty {
                                MessagePreview(geometry: g, onTap: {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        withAnimation {
                                            detent = PresentationDetent.fraction(1)
                                            showMessages = true
                                        }
                                    }
                                })
                                .frame(height: g.size.height - 32)
                                .frame(maxHeight: 100)
                                .padding([.leading, .trailing])
//                                .padding([.top, .bottom], 10)
                            } else {
                                NoMessagesView(canSend: helpRequest.myStatus() >= 1 ? true : false,
                                               onTap: {
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                        withAnimation {
                                                            detent = PresentationDetent.fraction(1)
                                                            showMessages = true
                                                        }
                                                    }
                                                })
                                    .frame(height: g.size.height - 32)
                                    .frame(maxHeight: 100)
                                    .padding([.leading, .trailing])
                                    .padding([.top, .bottom], 10)
                            }
                        }
                        .frame(height: 100)
                        
                        Text("All Respondents")
                            .font(.headline)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.leading, .top])
                        
                        RespondentsView(isExpanded: .constant(true), isFolded: .constant(false))
                            .environmentObject(helpRequest)
                            .frame(height: bounds.height / 2, alignment: .top)
                            .animation(.linear, value: detent)
                        
                    }
                } else {
                    //messenger
                    VStack {
                        MessengerView(focused: $focused,
                                      showMessages: $showMessages
                        )
                        .environmentObject(helpRequest)
                        
                        Spacer()
                        
                        //message capsule
                        MessageCapsuleView(
                            showMessages: $showMessages,
                            onToggleMessenger: {
                                withAnimation(.easeInOut) {
                                    detent = .fraction(showMessages ? 0.45 : 0.97)
                                    showMessages.toggle()
                                    hideKeyboard()
                                }
                            },
                            focused: $focused
                        )
                    }
                }
            }
        }
    }
}

struct RespondentHelpRequestView_Previews: PreviewProvider {
    static var previews: some View {
        
        let di = Environment.bootstrapLoggedIn(currentPage: .home).diContainer
        RespondentHelpRequestView(
            helpInteractor: di.interactors.help,
//            helpRequest: HelpRequestState(id: "6423f2069b242284be3728b5", userID: "6408ecb25cdef284ddf7dd44")
            helpRequest: HelpRequestState()
        )
            .environmentObject(di.appState)
    }
}

struct NoMessagesView: View {
    
    var canSend: Bool = false
    var onTap: () -> Void = {}
    
    @State var tapped = false
    
    var body: some View {
        VStack(spacing: 3) {
            
            Spacer()
            
            Image(systemName: "message.fill")
                .font(.title2)
                .foregroundColor(.adaptiveBlack)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("There are no messages yet")
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .center)
            
            if canSend {
                Text("Send a message first")
                    .font(.body)
                    .foregroundColor(.sysblue)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                EmptyView()
            }
            
            Spacer()
        }
        .frame(maxHeight: .infinity)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .opacity(tapped ? 0.5 : 1)
        .shadow(color: .black.opacity(tapped ? 0 : 0.15), radius: 10)
        .scaleEffect(tapped ? 0.98 : 1)
        .contentShape(Rectangle())
        .onTapGesture(perform: {
            tapped = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                tapped = false
                onTap()
            }
        })
        .animation(.easeInOut, value: tapped)
    }
}

struct MyStatusView: View {
    
    @EnvironmentObject var helpRequest: HelpRequestState
    
    @State var loading = false
    
    var geometry: GeometryProxy
    
    var onOnTheWay: () -> Void = {}
    var onTap: () -> Void = {}
    
    @State var tapped = false
    
    var body: some View {
        HStack {
            
            let rStatus = RespondentStatus.init(rawValue: helpRequest.myStatus())!
            
            ZStack {
                Text(helpRequest.myName()[0].uppercased() + helpRequest.mySurname()[0].uppercased())
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.3), radius: 5)
            }
            .frame(width: geometry.size.height * 0.8, height: geometry.size.height * 0.8)
            .frame(maxHeight: 100)
            .background(AccountGradient.getByID(id: helpRequest.myColorScheme()))
            .clipShape(Circle())
            .shadow(color: rStatus.shadowColor, radius: 5)
            .overlay {
                VStack {
                    Image(systemName: rStatus.glyphSystemName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(rStatus.color)
                        .frame(height: 25)
                        .background(
                            Color.adaptiveWhite.mask(Circle().scale(0.86))
                        )
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    Spacer()
                }
            }
            
            
            VStack(spacing: 7) {
                
                Text("You")
                    .font(.headline)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(rStatus.statusString)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            //buttons
            VStack(alignment: .center) {
                Button {
                    //on the way
                    loading = true
                    onOnTheWay()
                } label: {
                    
                    if loading {
                        ProgressView()
                    } else {
                        Image(systemName: "figure.walk")
                            .font(.body)
                            .foregroundColor(.green)
                        
                        Text("On My Way")
                            .font(.body)
                            .foregroundColor(.green)
                    }
                    
                }
                .disabled(rStatus.rawValue == 2 || loading)
                .controlSize(.large)
                .buttonStyle(.bordered)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(10)
        .frame(height: geometry.size.height)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .opacity(tapped ? 0.5 : 1)
        .shadow(color: .black.opacity(tapped ? 0 : 0.15), radius: 10)
        .scaleEffect(tapped ? 0.98 : 1)
        .contentShape(Rectangle())
        .onTapGesture(perform: {
            tapped = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                tapped = false
                onTap()
            }
        })
        .animation(.easeInOut, value: tapped)
        .onChange(of: helpRequest.myStatus()) { _ in
            loading = false
        }
    }
}
