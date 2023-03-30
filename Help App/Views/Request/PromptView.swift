//
//  PromptView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 27/03/2023.
//

import SwiftUI
import MapKit

struct PromptView: View {
    
    @EnvironmentObject var appState: AppState
    
    var helpInteractor: HelpInteractor
    
    
    @State var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 40.83834587046632,
            longitude: 14.254053016537693),
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
    
    @State var detent: PresentationDetent = .fraction(0.45)
    
    @State var now = Date()
    
    @StateObject var helpRequest: HelpRequestState
    
    @Binding var showHelpRequestPrompt: Bool
    
    @State var showContent = true
    
    @Binding var ownerAnnotation: [AnnotationItem]
    @State var distance: String = ""
    
    func onAccept() {
//        DispatchQueue.main.async {
//            withAnimation {
//                showHelpRequestPrompt = false
//            }
//        }
        showContent = false
        appState.showThumbnail = true
        helpInteractor.acceptHelpRequest(firstName: helpRequest.myName(), helpRequestID: helpRequest.helpRequestID ?? "")
        if #available(iOS 16.0, *) {
            let keyWindow = UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .first(where: { $0 is UIWindowScene })
                .flatMap { $0 as? UIWindowScene }?.windows
                .first(where: \.isKeyWindow)

            if let window = keyWindow {
                window.rootViewController?.presentedViewController?.dismiss(animated: true)
            }
        }
    }
    
    func onReject() {
//        DispatchQueue.main.async {
//            withAnimation {
//                showHelpRequestPrompt = false
//            }
//        }
        showContent = false
        helpInteractor.rejectHelpRequest(firstName: helpRequest.myName())
        //workarund the bug in iOS 16: https://developer.apple.com/forums/thread/716310
        if #available(iOS 16.0, *) {
            let keyWindow = UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .first(where: { $0 is UIWindowScene })
                .flatMap { $0 as? UIWindowScene }?.windows
                .first(where: \.isKeyWindow)

            if let window = keyWindow {
                window.rootViewController?.presentedViewController?.dismiss(animated: true)
            }
        }
        showHelpRequestPrompt = false
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
            Map(coordinateRegion: $region,
                interactionModes: .all,
                showsUserLocation: true,
                userTrackingMode: $tracking,
                annotationItems: ownerAnnotation,
                annotationContent: { locationPoint in
                MapAnnotation(coordinate: locationPoint.coordinate) {
                    UserLocationPin(
                        locationPoint: locationPoint,
                        region: $region,
                        distance: $distance,
                        showDistanceMessage: .constant(false),
                        owner: helpRequest.owner != nil ? $helpRequest.owner : .constant(OwnerModel(userID: "", firstName: "", lastName: "", colorScheme: 1))
                    )
                }
            }
            )
            .edgesIgnoringSafeArea(.all)
            
            stopwatch
                .padding(.top)
                .onAppear {
                    startStopwatch()
                }
                .onDisappear {
                    stopStopwatch()
                }
            
            
        }
        .task {
            _ = getCurrentRegion()
        }
        .transparentSheet(show: .constant(true), onDismiss: {}) {
            PromptContentView(detent: $detent,
                              onAccept: onAccept,
                              onReject: onReject)
                .environmentObject(helpRequest)
                .presentationDetents(
                    undimmed: [.fraction(0.45), .fraction(1)],
                    largestUndimmed: .fraction(0.98),
                    selection: $detent
                )
                .background(Color.white.opacity(0))
                .interactiveDismissDisabled(true)
                .if(helpRequest.owner == nil) { config in
                    config.redacted(reason: .placeholder)
                }
        }
        .onChange(of: ownerAnnotation) { newValue in
            if let a = ownerAnnotation.last {
                region = a.getMKMapRectRegion()
                distance = a.getDistanceToUser()
            }
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

struct PromptContentView: View {
    
    @Binding var detent: PresentationDetent
    
    @EnvironmentObject var helpRequest: HelpRequestState
    
    @State var showMessages = false
    
    @Namespace private var messageEffect
    
    var onAccept: () -> Void = {}
    var onReject: () -> Void = {}
    
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
                                //sos
                            } label: {
                                Text("500m")
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.large)

                        }
                        .padding()
                        
                        GeometryReader { g in
                            if !helpRequest.messages.isEmpty {
                               
                                    MessagePreview(geometry: g, messageEffect: _messageEffect, onTap: {
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
                                
                            } else {
                                NoMessagesView(canSend: false)
                                    .frame(height: g.size.height - 32)
                                    .frame(maxHeight: 100)
                                    .padding([.leading, .trailing])
                                    .padding([.top, .bottom], 10)
                            }
                        }
                        .frame(maxHeight: 100)
                    }
                } else {
                    MessengerView(focused: .constant(false),
                                  showMessages: $showMessages
                                  ,messageEffect: _messageEffect
                    )
                    .environmentObject(helpRequest)
                }
                
                Spacer()
                
                //action buttons
                VStack {
                    
                    if showMessages {
                        Button {
                            //hide messages
                            withAnimation {
                                showMessages = false
                                detent = .fraction(0.45)
                            }
                        } label: {
                            Text("Hide Chat")
                                .foregroundColor(.white)
                        }
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        .controlSize(.large)
                        .padding(.top)

                    }
                    
                    Button {
                        //accept
                        onAccept()
                    } label: {
                        Text("Accept")
                            .font(.title)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(SystemLargeButton(color: .green))
                    .padding([.leading, .trailing])
                    .shadow(color: .black.opacity(0.15), radius: 10)
                    .padding(.top)
                    
                    Button {
                        //reject
                        onReject()
                    } label: {
                        Text("Reject")
                            .font(.title2)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(10)
                    

                }
            }
        }
        .onChange(of: detent) { newValue in
            if newValue == PresentationDetent.fraction(1) {
                showMessages = true
            } else if showMessages {
                showMessages = false
            }
        }
        
    }
}

struct MessagePreview: View {
    
    @EnvironmentObject var helpRequest: HelpRequestState
    
    var geometry: GeometryProxy
    
    @Namespace var messageEffect
    
    var onTap: () -> Void = {}
    
    @State var tapped: Bool = false
    
    var body: some View {
        HStack {
            
            let lastMessage = helpRequest.messages.last!
            
            ZStack {
                Text(lastMessage.firstName[0].uppercased())
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.3), radius: 5)
            }
            .frame(width: geometry.size.height * 0.8, height: geometry.size.height * 0.8)
            .frame(maxHeight: 100)
            .background(AccountGradient.getByID(id: helpRequest.owner?.colorScheme ?? 1))
            .clipShape(Circle())
            
            
            VStack(spacing: 7) {
                HStack(alignment: .top) {
                    
                    Text(lastMessage.firstName)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Text(Date.toMessageFormat(isoDate: lastMessage.timeStamp))
                        .font(.footnote)
                        .fontWeight(.light)
                }
                
                HStack(alignment: .top) {
                    
                    Text(lastMessage.body)
                        .font(.subheadline)
                        .lineLimit(2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .id(lastMessage.messageID)
                        .matchedGeometryEffect(id: lastMessage.messageID, in: messageEffect)
                    
                    Spacer()
                    
                    Text(String(helpRequest.messages.count))
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .padding(10)
                        .background(.regularMaterial)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.15), radius: 5)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
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
    }
}

struct PromptView_Previews: PreviewProvider {
    static var previews: some View {
//        PromptView(helpRequest: HelpRequestState(id: "6421ce2de057e10b6209e9b6"))
        let di = Environment.bootstrapLoggedIn(currentPage: .home).diContainer
        PromptView(
            helpInteractor: di.interactors.help,
            helpRequest: HelpRequestState(),
            showHelpRequestPrompt: .constant(true), ownerAnnotation: .constant([]))
        .environmentObject(di.appState)
    }
}
