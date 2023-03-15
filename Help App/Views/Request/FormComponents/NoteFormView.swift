//
//  NoteFormView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 14/03/2023.
//

import SwiftUI

struct NoteFormView: View {
    
    @State var message: String = ""
    
    @GestureState var isPressingRecord = false
    @State var isRecording: Bool = false
    
    @State var animate = false
    
    var keyboardIsShown: FocusState<Bool>.Binding
    
    var audioRecorder = AudioRecorder(session: "test")
    
    var body: some View {
        VStack(spacing: 16) {
            
            HStack {
                Text("Add a Message")
                    .font(.title3)
                    .fontWeight(.bold)
                .padding(.leading)
                
                Spacer()
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
                
                Spacer()
                
                //audio message button
                ZStack {
                    
                    if isPressingRecord {
                        
                        ZStack {
                            Circle().fill(.red.opacity(0.25)).frame(width: 90, height: 90).scaleEffect(self.animate ? 1 : 0.001)
                            Circle().fill(.red.opacity(0.35)).frame(width: 75, height: 75).scaleEffect(self.animate ? 1 : 0.001)
                            Circle().fill(.red.opacity(0.45)).frame(width: 60, height: 60).scaleEffect(self.animate ? 1 : 0.001)
                        }
                        .onAppear { self.animate = true }
                        .onDisappear { self.animate = false }
                        .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animate)
                    }
                    
                    Image(systemName: "mic.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .foregroundColor(isPressingRecord ? .red : .sysblue)
                }
                .frame(width: 50, height: 50)
                .scaleEffect(isPressingRecord ? 1.2 : 1)
                .animation(.easeInOut, value: isPressingRecord)
                .onLongPressGesture(
                    minimumDuration: .infinity,
                    pressing: { isPressing in
                        if isPressing {
                            print("start rec")
                            audioRecorder.startRecording()
                        } else {
                            print("end rec")
                            audioRecorder.stopRecording()
                            let recordings = audioRecorder.getSessionRecordings()
                        }
                    },
                    perform: {}
                )
            }
            .padding([.leading, .trailing])
            
        }
    }
}
