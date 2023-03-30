//
//  VictimHelpRequestView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 24/03/2023.
//

import SwiftUI
import MapKit

struct VictimHelpRequestView: View {
    
    @SwiftUI.Environment(\.colorScheme) var colorScheme : ColorScheme
    var helpInteractor: HelpInteractor
    
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
    
    @State var detent: PresentationDetent = .fraction(0.45)
    
    @StateObject var helpRequest: HelpRequestState
    @State var showResolutionDialogue = false
    @State var showContent = false
    
    @State var annotationItems: [AnnotationItem] = []
    
    @State var distance: String = ""
    @State var showDistanceMessage = false
    
    @State var showSOSConfirmation = false
    @State var showSOSError = false
    
    func onSendSOS() {
        if let helpID = helpRequest.helpRequestID {
            showSOSError = false
            Task {
                let status = await helpInteractor.sendSOS(helpRequestID: helpID)
                if status {
                    DispatchQueue.main.async {
                        showSOSConfirmation = true
                    }
                } else {
                    showSOSError = true
                    showSOSConfirmation = true
                }
            }
        }
    }
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region,
                interactionModes: .all,
                showsUserLocation: true,
                userTrackingMode: $tracking,
                annotationItems: annotationItems,
                annotationContent: { locationPoint in
                    MapAnnotation(coordinate: locationPoint.coordinate) {
                    UserLocationPin(locationPoint: locationPoint,
                                    region: $region,
                                    distance: $distance,
                                    showDistanceMessage: $showDistanceMessage,
                                    owner: $helpRequest.owner,
                                    victimView: true
                                    )
                    }
                }
            )
                .edgesIgnoringSafeArea(.all)
            
            ZStack {
                if showDistanceMessage {
                    Button {
                        //
                    } label: {
                        Text(distance)
                            .foregroundColor(.adaptiveBlack)
                    }
                    .controlSize(.large)
                    .buttonStyle(.bordered)
                    .accentColor(.clear)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: .black.opacity(0.3), radius: 10)
                }

            }
            .animation(.easeInOut(duration: 1), value: showDistanceMessage)
            
            topRightCornerButtons
        }
        .transparentSheet(show: $showContent) {
            //onDismiss?
        } content: {
            VictimHRContent(detent: $detent, onSOS: onSendSOS, showSOSConfirmation: $showSOSConfirmation, showSOSError: $showSOSError)
                .environmentObject(helpRequest)
                .presentationDetents(
                    undimmed: [.fraction(0.25), .fraction(0.45), .fraction(0.97), .fraction(1)],
                    largestUndimmed: .fraction(1),
                    selection: $detent
                )
                .interactiveDismissDisabled(true)
                .background(Color.white.opacity(colorScheme == .light ? 0.5 : 0))
                .confirmationDialog("Resolve your help request?",
                                    isPresented: $showResolutionDialogue) {
                    Button("I am safe now", role: .destructive) {
                        helpInteractor.resolveHelpRequest()
                    }
                    Button("Cancel", role: .cancel) {
                        DispatchQueue.main.async {
                            showResolutionDialogue = false
                            showContent = true
                        }
                    }
                }
            
        }
        .onAppear {
            print("onAppear")
            #if !targetEnvironment(simulator)
            _ = getCurrentRegion()
            annotationItems = helpRequest.getRespondentMapItems()
            guard let id = UserDefaults.standard.string(forKey: "helpRequestID") else {
                print("user defauls sucks")
                return
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
            SocketInteractor.standard.onUpdate = { updatedModel in
                helpRequest.updateFields(model: updatedModel)
                annotationItems = helpRequest.getRespondentMapItems()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                showContent = true
                detent = .fraction(0.45)
            }
            #else
            showContent = true
            annotationItems = helpRequest.getRespondentMapItems()
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
                        showResolutionDialogue = true
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
}

struct VictimHRContent: View {
    
    @Binding var detent: PresentationDetent
    var onSOS: () -> Void = {}
    @Binding var showSOSConfirmation: Bool
    @Binding var showSOSError: Bool
    
    @EnvironmentObject var helpRequest: HelpRequestState
    
    @State var showMessages: Bool = false
    
    @State var isExpanded: Bool = false
    @State var isFolded: Bool = false
    
    
    @State var focused: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
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
                                    
                                    Text(helpRequest.currentStatus?.progressMessageOwner ?? "Progress Message Placeholder")
                                        .font(.footnote)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.leading)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Button {
                                onSOS()
                            } label: {
                                Text("SOS")
                            }
                            .tint(.red)
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)

                        }
                        .padding()
                        
                        Spacer()
                        
                        //respondents
                        GeometryReader { respondentGeometry in
                            RespondentsView(isExpanded: $isExpanded, isFolded: $isFolded)
                                .environmentObject(helpRequest)
                                .frame(maxHeight: geometry.size.height / 2)
                                .opacity(detent == .fraction(0.25) ? 0 : 1)
                                .animation(.linear, value: detent)
                                .zIndex(4)
                        }
                        .padding(.top)
                        
                        if detent == .fraction(0.97) {
                            withAnimation {
                                Spacer()
                            }
                        }
                    }
                    
                } else {
                    MessengerView(focused: $focused, showMessages: $showMessages)
                        .environmentObject(helpRequest)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            hideKeyboard()
                        }
                }
                
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
            .alert(showSOSError ? "Error occured" : "SOS was sent to all respondents.", isPresented: $showSOSConfirmation) {
                Button("OK", role: .cancel) { }
            }
            .onChange(of: detent) { newValue in
                if newValue == .fraction(0.25) {
                    withAnimation(.linear(duration: 0.2)) {
                        isFolded = true
                        isExpanded = false
                        showMessages = false
                    }
                } else if newValue == .fraction(0.97) {
                    withAnimation {
                        isExpanded = true
                        isFolded = false
                    }
                } else if newValue == .fraction(0.45) {
                    withAnimation {
                        isExpanded = false
                        isFolded = false
                        showMessages = false
                    }
                }
            }
            .onAppear {
                detent = .fraction(0.45)
            }
            .if(helpRequest.owner == nil) { view in
                withAnimation {
                    view.redacted(reason: .placeholder)
                }
            }
        }
    }
}

struct RespondentsView: View {
    
    @EnvironmentObject var helpRequest: HelpRequestState
    
    @SwiftUI.Environment(\.colorScheme) var colorScheme : ColorScheme
    
    @Binding var isExpanded: Bool
    @Binding var isFolded: Bool
    
    let diameter: CGFloat = 100
    
    @Namespace private var respondentEffect
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        GeometryReader { geometry in
            Group {
                if isExpanded {
                    verticalRepresentation(geometry: geometry)
                } else {
                    horizontalRepresentation(geometry: geometry)
                }
            }
            .frame(maxWidth: .infinity)
            .scaleEffect(isFolded ? 0 : 1)
            .opacity(isFolded ? 0 : 1)
            .frame(height: isFolded ? 0 : geometry.size.height, alignment: .top)
            .padding([.leading, .trailing])
            
        }
    }
    
    private func verticalRepresentation(geometry: GeometryProxy) -> some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(helpRequest.respondents.sorted(by: { elem1, elem2 in
                return elem1.status > elem2.status
            }), id: \.userID) { respondent in
                
                let rStatus = RespondentStatus.init(rawValue: respondent.status)!
                
                respondentThumbnailView(
                    respondent: respondent,
                    rStatus: rStatus,
                    geometry: geometry,
                    diameter: geometry.size.height / 4
                )
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.16), radius: 17, x: 0, y: 2)
    }
    
    private func horizontalRepresentation(geometry: GeometryProxy) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {

            HStack(alignment: .center) {

                ForEach(helpRequest.respondents.sorted(by: { elem1, elem2 in
                    return elem1.status > elem2.status
                }), id: \.userID) { respondent in

                        let rStatus = RespondentStatus.init(rawValue: respondent.status)!

                        respondentThumbnailView(
                            respondent: respondent,
                            rStatus: rStatus,
                            geometry: geometry,
                            diameter: geometry.size.height / 2
                        )
                    }
                }

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.16), radius: 17, x: 0, y: 2)
    }
    
    private func respondentThumbnailView(respondent: RespondentModel, rStatus: RespondentStatus, geometry: GeometryProxy, diameter: CGFloat) -> some View {
        VStack(spacing: 6) {
            ZStack {
                Text(respondent.firstName[0].uppercased() + respondent.lastName[0].uppercased())
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.3), radius: 5)
            }
            .frame(width: diameter, height: diameter)
            .frame(maxHeight: 100)
            .background(AccountGradient.getByID(id: respondent.colorScheme))
            .clipShape(Circle())
            .shadow(color: rStatus.shadowColor, radius: 5)
            .overlay {
                VStack {
                    Image(systemName: rStatus.glyphSystemName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(rStatus.color)
                        .frame(height: diameter / 4)
                        .background(
                            Color.adaptiveWhite.mask(Circle().scale(0.86))
                        )
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    Spacer()
                }
            }
            
            Text(respondent.firstName)
                .font(.headline)
                .fontWeight(.medium)
            
            Text(rStatus.statusString)
                .font(.subheadline)
        }
        .matchedGeometryEffect(id: respondent.userID, in: respondentEffect)
        .frame(maxHeight: .infinity, alignment: .center)
        .padding(8)
    }
}

struct MessengerView: View {
    
    @EnvironmentObject var helpRequest: HelpRequestState
    
    @Binding var focused: Bool
    @Binding var showMessages: Bool
    
    let END = UUID()
    
    @Namespace var messageEffect
    
    var body: some View {
        ZStack {
            
            //messages renderer
            chatMessages()
                .padding()
            
            VStack {
                Text("Messages:")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                Spacer()
            }
            
        }
    }
    
    func myMessageView(message: MessageModel) -> some View {
        HStack {
            Spacer()
            
            VStack {
                Text(message.body)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .matchedGeometryEffect(id: message.messageID, in: messageEffect)
                
                Text(Date.toMessageFormat(isoDate: message.timeStamp))
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                
            }
            .padding(5)
            .background(Color(uiColor: .tertiarySystemGroupedBackground))
            .cornerRadius(16, corners: [.topRight, .topLeft, .bottomLeft])
            .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 3)
            .padding(.leading, 30)
                
        }
    }
    
    func incomingMessage(message: MessageModel) -> some View {
        HStack {
            
            //icon
            VStack {
                Spacer()
                
                ZStack {
                    Text(message.firstName[0].uppercased())
                        .font(.system(.caption2, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.3), radius: 5)
                }
                .frame(width: 25, height: 25)
                .background(helpRequest.owner?.userID == message.userID ?
                            LinearGradient(colors: [.red], startPoint: .topLeading, endPoint: .bottomTrailing)
                    :
                    AccountGradient.getByID(id: message.colorScheme))
                .clipShape(Circle())
            }
            
            
            VStack {
                
                Text(message.firstName)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .padding(.leading, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(message.body)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .matchedGeometryEffect(id: message.messageID, in: messageEffect)
                
                Text(Date.toMessageFormat(isoDate: message.timeStamp))
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                
            }
            .padding(5)
            .background(Color(uiColor: .tertiarySystemGroupedBackground))
            .cornerRadius(16, corners: [.topRight, .topLeft, .bottomRight])
            .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 3)
            .padding(.trailing, 30)
            
            Spacer()
        }
    }
    
    @ViewBuilder func chatMessages() -> some View {
        ScrollView(showsIndicators: false) {
            ScrollViewReader { scroll in
                LazyVStack(spacing: 5) {
                    Spacer().frame(height: 75)
                    
                    ForEach(helpRequest.messages, id: \.messageID) { message in
                        if message.userID == helpRequest.myUserID {
                            myMessageView(message: message)
                                .id(message.messageID)
                        } else {
                            incomingMessage(message: message)
                                .id(message.messageID)
                        }
                    }
                    
                    Spacer().frame(height: 100)
                        .id(END)
                }
                .onAppear {
                    withAnimation {
                        scroll.scrollTo(END)
                    }
                }
                .onChange(of: focused) { newValue in
                    withAnimation {
                        scroll.scrollTo(END)
                    }
                }
                .onChange(of: showMessages) { newValue in
                    withAnimation {
                        scroll.scrollTo(END)
                    }
                }
            }
        }
    }
}

struct MessageCapsuleView: View {
    
    @SwiftUI.Environment(\.colorScheme) var colorScheme : ColorScheme
    @EnvironmentObject var helpRequest: HelpRequestState
    
    @Binding var showMessages: Bool
    
    var onToggleMessenger: () -> Void
    
    @State var message: String = ""
    
    @Binding var focused: Bool
    
    @FocusState var keyboard: Bool
    
    func sendMessage() {
        let messageModel = MessageModel(
            messageID: UUID().uuidString,
            userID: helpRequest.myUserID,
            firstName: helpRequest.myName(),
            colorScheme: helpRequest.myColorScheme(),
            isAudio: false,
            body: message,
            timeStamp: Date().toString(dateFormat: "YYYY-MM-DDTHH:mm:ss.sssZ"),
            data: nil
        )
        helpRequest.messages.append(messageModel)
        SocketInteractor.standard.sendMessage(message: message)
        message = ""
    }
    
    var body: some View {
        HStack {
            ZStack {
                TextField("Type Here", text: $message, axis: .horizontal)
                    .frame(height: 50)
                    .padding([.leading, .trailing])
                    .padding(.trailing, 100)
                    .focused($keyboard)
                    .onSubmit {
                        sendMessage()
                    }
                
                //button
                HStack {
                    Button {
                        onToggleMessenger()
                    } label: {
                        if showMessages {
                            Text("Hide Chat")
                        } else {
                            Text("All Messages")
                        }
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.regular)
                    .buttonBorderShape(.capsule)
                    .tint(showMessages ? nil : Color.sysblue)
                    .padding(.trailing, 10)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .background(Color.white.opacity(colorScheme == .light ? 1 : 0.2))
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .frame(minHeight: 50, maxHeight: 100)
            .padding([.leading, .trailing])
            .onChange(of: keyboard) { newValue in
                keyboard = newValue
                focused = newValue
                if newValue == true && !showMessages {
                    onToggleMessenger()
                }
            }
            
            if !message.isEmpty {
                Button {
                    sendMessage()
                } label: {
                    Image(systemName: "arrow.up")
                }
                .buttonStyle(.borderedProminent)
                .tint(.sysblue)
                .buttonBorderShape(.capsule)
                .controlSize(.regular)
                .padding([.trailing])
                .padding(.leading, -10)
            }
            
        }
        .animation(.easeInOut, value: message)
    }
}

struct VictimHelpRequestView_Previews: PreviewProvider {
    static var previews: some View {
        let helpInteractor = Environment.bootstrapLoggedIn(currentPage: .home).diContainer.interactors.help
        VictimHelpRequestView(helpInteractor: helpInteractor, helpRequest: HelpRequestState())
    }
}
