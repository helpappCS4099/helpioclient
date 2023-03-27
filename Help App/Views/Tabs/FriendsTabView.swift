//
//  FriendsTabView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 02/02/2023.
//

import SwiftUI

struct FriendsTabView: View {
    
    var userInteractor: UserInteractor
    
    @State var queryString: String = ""
    
//    @State fileprivate var myFriends
    
    @State var showAddNewFriendsSheet: Bool = false
    
    @State var user: UserModel?
    @State var friends: [FriendModel] = []
    
    func onSearch(searchString: String) async -> [FriendModel] {
        let (searchResults, _) = await userInteractor.searchUsers(by: searchString, myUserID: user!.userID)
        return userInteractor.convertUsersToFriends(for: user!, with: searchResults)
    }
    
    func addFriend(friendUserID: String) async {
        let (updatedUser, _, _) = await userInteractor.addFriend(myUserID: user!.userID, friendUserID: friendUserID)
        if let updatedUser {
            user = updatedUser
            friends = user!.friends
            showAddNewFriendsSheet = false
        }
    }
    
    func deleteFriend(friendUserID: String) async {
        let (updatedUser, _, _) = await userInteractor.deleteFriend(myUserID: user!.userID, friendUserID: friendUserID)
        if let updatedUser {
            user = updatedUser
            friends = user!.friends
            showAddNewFriendsSheet = false
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                VStack {
                    List {
                        if !friends.isEmpty {
                            
                            Section(header: Text("Your Friends")) {
                                ForEach(friends.filter{$0.status == 1}, id: \.userID) { friend in
                                    FriendListItemView(
                                        friend: friend,
                                        onDelete: {
                                            Task {
                                                await deleteFriend(friendUserID: friend.userID)
                                            }
                                        },
                                        onAdd: {
                                            Task {
                                                await addFriend(friendUserID: friend.userID)
                                            }
                                        }
                                    )
                                    .listRowInsets(EdgeInsets(top: 6,
                                                              leading: 6,
                                                              bottom: 6,
                                                              trailing: 6)
                                    )
                                }
                            }
                            
                            Section(header: Text("Friend Requests")) {
                                ForEach(friends.filter{$0.status != 1}, id: \.userID) { requestedFriend in
                                    FriendListItemView(
                                        friend: requestedFriend,
                                        onDelete: {
                                            Task {
                                                await deleteFriend(friendUserID: requestedFriend.userID)
                                            }
                                        },
                                        onAdd: {
                                            Task {
                                                await addFriend(friendUserID: requestedFriend.userID)
                                            }
                                        }
                                    )
                                        .listRowInsets(EdgeInsets(top: 6,
                                                                  leading: 6,
                                                                  bottom: 6,
                                                                  trailing: 6)
                                        )
                                }
                            }
                            
                        } else {
                            VStack(alignment: .center, spacing: 10) {
                                Text("You have not added friends yet")
                                    .font(.headline)
                                
                                Text("Find people to add and use as your emergency contacts")
                                    .multilineTextAlignment(.center)
                                    .font(.subheadline)
                                
                                Image(systemName: "person.fill.badge.plus")
                                    .font(.system(size: 50))
                                    .foregroundColor(.sysblue)
                            }
                            .frame(maxWidth: .infinity)
                            .listRowInsets(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                        }
                    }
                    .refreshable {
                        let (myUserObject, _) = await userInteractor.getMyself()
                        if let myUserObject = myUserObject {
                            user = myUserObject
                            friends = myUserObject.friends
                        }
                    }
                }
                
                VStack {
                    Spacer()
                    
                    Button {
                        if user != nil {
                            showAddNewFriendsSheet = true
                        }
                    } label: {
                        Text("\(Image(systemName: "person.fill.badge.plus")) Add Friends")
                            .font(.title2)
                            .fontWeight(.regular)
                            .frame(width: bounds.width - 60)
                    }
                    .buttonStyle(SystemLargeButton(hasShadow: true))
                    .padding()
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
            }
            .navigationTitle("Friends")
            .sheet(isPresented: $showAddNewFriendsSheet) {
                AddNewFriendsView(
                    onSearch: { searchString in
                        let result = await onSearch(searchString: searchString)
                        return result
                    },
                    onAdd: { friendID in
                        Task {
                            await addFriend(friendUserID: friendID)
                        }
                    },
                    onDelete: { friendID in
                        Task {
                            await deleteFriend(friendUserID: friendID)
                        }
                    },
                    showSheet: $showAddNewFriendsSheet)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.hidden)
            }
            
        }
        .searchable(text: $queryString)
        .task {
            //get a user object and fill in friends
            let (myUserObject, opStatus) = await userInteractor.getMyself()
            print("getting my user object: ", opStatus)
            if let myUserObject = myUserObject {
                user = myUserObject
                friends = myUserObject.friends
            }
        }
    }
}

struct FriendsTabView_Previews: PreviewProvider {
    static var previews: some View {
        let env = Environment.bootstrapLoggedIn(currentPage: .friends)
        
        FriendsTabView(userInteractor: env.diContainer.interactors.user)
    }
}
