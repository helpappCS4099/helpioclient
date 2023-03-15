//
//  FriendFormView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 13/03/2023.
//

import SwiftUI

struct FriendFormView: View {
    
    @Binding var criticalSituation: CriticalSituation
    
    @State var tapped = false
    
    var user: UserModel
    
    @State var selectedFriends: [String] = []
    @State var allFriends: [FriendModel] = []
    
    var body: some View {
        Group {
            VStack(spacing: 16) {
                //selected request category
                HStack {
                    Text("Choose Category")
                        .font(.title3)
                        .fontWeight(.bold)
                    .padding(.leading)
                    
                    Spacer()
                }
                
                HStack {
                    //icon
                    criticalSituation.image
                        .resizable()
                        .foregroundColor(.adaptiveBlack)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .padding()
                    //text
                    Text(criticalSituation.rawValue)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    //button
                    Button {
                        //go back to category form
                    } label: {
                        Text("Change")
                            .foregroundColor(.adaptiveBlack)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    .tint(.adaptiveLightButton)
                    .shadow(color: .black.opacity(0.1), radius: 10)
                    .padding()

                }
                .background(Color(uiColor: .tertiarySystemFill))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .frame(width: bounds.width - 32, height: 75)
                .contentShape(Rectangle())
                .opacity(tapped ? 0.7 : 1)
                .onTapGesture {
                    tapped = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        tapped = false
                        //go back to category form
                    }
                }
            }
            
            VStack(spacing: 16) {
                //friend list
                HStack {
                    Text("Choose Friends")
                        .font(.title3)
                        .fontWeight(.bold)
                    .padding(.leading)
                    
                    Spacer()
                }
                
                VStack(spacing: 5) {
                    ForEach(0 ..< 10) { item in
                        ForEach(allFriends, id: \.userID) { friend in
                            FriendFormItemView(
                                friend: friend,
                                selectedFriends: $selectedFriends,
                                onSelect: { friendID in
                                    selectedFriends.append(friendID)
                                },
                                onRemove: { friendID in
                                    if let index = selectedFriends.firstIndex(where: {$0 == friendID}) {
                                        selectedFriends.remove(at: index)
                                    }
                                }
                            )
                            .padding([.leading, .trailing])
                        }
                    }
                }
            }
            
        }
        .frame(width: bounds.width)
        .onAppear {
            allFriends = user.friends.filter { $0.status == 1 }
            selectedFriends = allFriends.map({ friend in
                return friend.userID
            })
        }
    }
}

struct FriendFormView_Previews: PreviewProvider {
    static var previews: some View {
        FriendFormView(
            criticalSituation: .constant(.trauma),
            user: UserModel(userID: "sjkldjsldjlsd",
                                       email: "ar303@st-andrews.ac.uk",
                                       firstName: "Artem",
                                       lastName: "Rakhmanov",
                                       verified: true,
                                       currentHelpRequestID: "",
                                       colorScheme: 2,
                                       friends: [
                                           FriendModel(userID: "jskldsjldjlsd",
                                                       firstName: "Bob",
                                                       lastName: "Roberts",
                                                       colorScheme: 1,
                                                       status: 1,
                                                       email: "br202@st-andrews.ac.uk")
                                       ]))
    }
}
