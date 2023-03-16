//
//  FriendFormView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 13/03/2023.
//

import SwiftUI

struct FriendFormView: View {
    
    @Binding var criticalSituation: CriticalSituation
    @Binding var friends: [FriendModel]
    var onBackToCategory: () -> Void = {}
    
    @State var tapped = false
    
    @Binding var selectedFriends: [String]
    
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
                
                HStack(spacing: 0) {
                    //icon
                    criticalSituation.image
                        .resizable()
                        .foregroundColor(.adaptiveBlack)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .padding()
                    //text
                    Text(criticalSituation.rawValue)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    //button
                    Button {
                        //go back to category form
                        onBackToCategory()
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
                .frame(width: bounds.width - 32, height: 85)
                .background(Color(uiColor: .tertiarySystemFill))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .contentShape(Rectangle())
                .opacity(tapped ? 0.7 : 1)
                .onTapGesture {
                    tapped = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        tapped = false
                        onBackToCategory()
                    }
                }
            }
            
            VStack(spacing: 16) {
                //friend list
                VStack(spacing: 5) {
                    HStack {
                        Text("Choose Friends")
                            .font(.title3)
                            .fontWeight(.bold)
                        .padding(.leading)
                        
                        Spacer()
                    }
                    
//                    HStack {
//                        Text("")
//                            .font(.subheadline)
//                            .fontWeight(.medium)
//                        .padding(.leading)
//                        
//                        Spacer()
//                    }
                }
                
                VStack(spacing: 5) {
                    ForEach(friends, id: \.userID) { friend in
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
        .frame(width: bounds.width)
        .onAppear {
            selectedFriends = friends.map({ friend in
                return friend.userID
            })
        }
    }
}

struct FriendFormView_Previews: PreviewProvider {
    static var previews: some View {
        FriendFormView(
            criticalSituation: .constant(.trauma),
            friends: .constant([]),
            selectedFriends: .constant([])
        )
    }
}
