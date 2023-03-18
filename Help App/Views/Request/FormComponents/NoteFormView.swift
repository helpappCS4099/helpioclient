//
//  NoteFormView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 14/03/2023.
//

import SwiftUI

struct NoteFormView: View {
    
    @Binding var messages: [String]
    
    @State var message: String = ""
    
    @GestureState var isPressingRecord = false
    @State var isRecording: Bool = false
    
    @State var animate = false
    
    var keyboardIsShown: FocusState<Bool>.Binding
    
    var audioRecorder = AudioRecorder(session: "test")
    
    var onMessageSend: () -> Void = {}  //func to trigger scroll back to textField
    
    @State var onTapSend: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            
            HStack {
                Text("Add a Message")
                    .font(.title3)
                    .fontWeight(.bold)
                .padding(.leading)
                
                Spacer()
            }
            
            //render messages here
            VStack {
                ForEach(messages, id: \.hashValue) { message in
                    HStack {
                        
                        Button {
                            //action
                            if let index = messages.firstIndex(where: { $0 == message }) {
                                messages.remove(at: index)
                            }
                            
                        } label: {
                            Image(systemName: "trash.fill")
                                .font(.system(size: 25))
                        }
                        .buttonStyle(.borderless)
                        .tint(.red)
                        
                        Spacer()
                        
                        Text(message)
                            .font(.body)
                            .multilineTextAlignment(.leading)
                            .padding(10)
                            .background(Color(uiColor: .tertiarySystemGroupedBackground))
                            .cornerRadius(16, corners: [.topRight, .topLeft, .bottomLeft])
                    }
                    .padding([.leading, .trailing])
                }
            }
            
            HStack {
                ZStack {
                    TextField("Type Here", text: $message, axis: .vertical)
                        .lineLimit(5)
                        .frame(minHeight: 50)
                        .padding([.leading, .trailing])
                        .focused(keyboardIsShown)
                }
                .background(Color(uiColor: .tertiarySystemFill))
                .frame(maxWidth: .infinity)
                .frame(minHeight: 50, maxHeight: 100)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                
                if (!message.isEmpty) {
                    Spacer()
                    
                    ZStack {
                        Image(systemName: "arrow.up.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .foregroundColor(.sysblue)
                            .background(Color.white)
                            .clipShape(Circle())
                            .opacity(onTapSend ? 0.5 : 1)
                            .onTapGesture {
                                onTapSend = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    onTapSend = false
                                    messages.append(message)
                                    message = ""
                                    onMessageSend()
                                }
                            }
                    }
                }
                
                //audio message button
//                ZStack {
//
//                    if isPressingRecord {
//
//                        ZStack {
//                            Circle().fill(.red.opacity(0.25)).frame(width: 90, height: 90).scaleEffect(self.animate ? 1 : 0.001)
//                            Circle().fill(.red.opacity(0.35)).frame(width: 75, height: 75).scaleEffect(self.animate ? 1 : 0.001)
//                            Circle().fill(.red.opacity(0.45)).frame(width: 60, height: 60).scaleEffect(self.animate ? 1 : 0.001)
//                        }
//                        .onAppear { self.animate = true }
//                        .onDisappear { self.animate = false }
//                        .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animate)
//                    }
//
//                    Image(systemName: "mic.circle.fill")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 50, height: 50)
//                        .foregroundColor(isPressingRecord ? .red : .sysblue)
//                }
//                .frame(width: 50, height: 50)
//                .scaleEffect(isPressingRecord ? 1.2 : 1)
//                .animation(.easeInOut, value: isPressingRecord)
//                .highPriorityGesture(
//                    LongPressGesture(
//                        minimumDuration: .infinity
//                    )
//                    .updating($isPressingRecord, body: { value, state, transaction in
//                        state = value
//                    })
//                )
            }
            .onChange(of: isPressingRecord) { newValue in
                let impact = UIImpactFeedbackGenerator(style: .heavy)
                impact.prepare()
                impact.impactOccurred()
                if newValue {
                    print("start rec")
                    audioRecorder.startRecording()
                } else {
                    print("end rec")
                    audioRecorder.stopRecording()
                    let _ = audioRecorder.getSessionRecordings()
                }
            }
            .padding([.leading, .trailing])
            
        }
    }
}
