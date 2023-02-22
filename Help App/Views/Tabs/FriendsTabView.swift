//
//  FriendsTabView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 02/02/2023.
//

import SwiftUI

struct FriendsTabView: View {
    
    @State var queryString: String = ""
    
//    @State fileprivate var myFriends
    
    @State var showAddNewFriendsSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                VStack {
                    List {
                        Section(header: Text("Friend Requests")) {
                            FriendListItemView(friendStatus: 3)
                                .listRowInsets(EdgeInsets())
                            
                            FriendListItemView(friendStatus: 2)
                                .listRowInsets(EdgeInsets())
                        }
                        
                        Section(header: Text("Your Friends")) {
                            FriendListItemView()
                                .listRowInsets(EdgeInsets())
                        }
                    }
                }
                .navigationTitle("Friends")
                
                VStack {
                    Spacer()
                    
                    Button {
                        showAddNewFriendsSheet = true
                    } label: {
                        Text("\(Image(systemName: "person.fill.badge.plus")) Add Friends")
                            .font(.title2)
                            .fontWeight(.regular)
                            .frame(width: bounds.width - 60)
                    }
                    .buttonStyle(SystemLargeButton(hasShadow: true))
                    .padding()
                }
            }
            .sheet(isPresented: $showAddNewFriendsSheet) {
                AddNewFriendsView(showSheet: $showAddNewFriendsSheet)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.hidden)
            }
        }
        .searchable(text: $queryString)
        .onAppear {
            
        }
    }
}

struct FriendsTabView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsTabView()
    }
}
