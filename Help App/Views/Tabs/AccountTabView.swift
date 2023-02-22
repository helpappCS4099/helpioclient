//
//  AccountTabView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 02/02/2023.
//

import SwiftUI

struct AccountTabView: View {
    
    var firstName: String = "Artem"
    var lastName: String = "Rakhmanov"
    var email: String = "ar303@st-andrews.ac.uk"
    var friendStatus: Int = 1
    
    let diameter: CGFloat = 150    //for circle
    
    @State var selectedColor: AccountGradient = .greenAsh
    
    @State var colorTappedID: Int?
    
    var body: some View {
        NavigationStack {
            List {
                
                ZStack {
                    HStack {
                        
                        VStack(alignment: .leading, spacing: 10) {
                            
                            Spacer()
                                .frame(height: 100)
                            
                            Text("\(firstName) \(lastName)")
                                .font(.title)
                                .fontWeight(.medium)
                            
                            Text(email)
                                .font(.subheadline)
                                .fontWeight(.light)
                            
                            Spacer()
                        }
                        .padding()
                        
                        Spacer()
                    }
                    .background(selectedColor.gradient)
                    
                    VStack {
                        
                        HStack {
                            Spacer()
                            
                            Image("heartGraphicRing")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 75)
                                .padding()
                        }
                        
                        Spacer()
                    }
                }
                .listRowInsets(EdgeInsets())
                
                //account color
                Section {
                    accountColorSelection()
                }
                
                Section(header: Text("Settings")) {
                    
                    centeredTextButton(text: "Permissions Settings", action: {})
                }
                
                Section {
                    centeredTextButton(text: "Log Out", isPlain: false, action: {})
                }
            
            }
        }
    }
    
    func accountColorSelection() -> some View {
        HStack {
            //circle
            ForEach(AccountGradient.allCases, id: \.id) { gradient in
                ZStack {
                    gradient.gradient
                        .mask(Circle())
                        .frame(height: 50)
                    
                    if selectedColor == gradient {
                        Circle()
                            .strokeBorder(Color.gray, lineWidth: 3)
                            .frame(height: 70)
                    }
                }
                .contentShape(Rectangle())
                .opacity(colorTappedID == gradient.id ? 0.5 : 1)
                .animation(.default, value: true)
                .onTapGesture {
                    colorTappedID = gradient.id
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        colorTappedID = nil
                        selectedColor = gradient
                    }
                }
            }
                
        }
    }
    
    func centeredTextButton(text: String, isPlain: Bool = true, action: @escaping () -> Void) -> some View {
        HStack {
            Spacer()
            
            Button(text) {
                action()
            }
            .foregroundColor(isPlain ? .adaptiveBlack : nil)
            
            Spacer()
        }
    }
}

struct AccountTabView_Previews: PreviewProvider {
    static var previews: some View {
        AccountTabView()
    }
}
