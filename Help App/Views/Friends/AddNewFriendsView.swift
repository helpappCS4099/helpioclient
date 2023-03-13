//
//  AddNewFriendsView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 22/02/2023.
//

import SwiftUI

struct AddNewFriendsView: View {
    
    var onSearch: (String) async -> [FriendModel]
    var onAdd: (String) async -> Void = {_ in}
    var onDelete: (String) async -> Void = {_ in}
    
    @State var queryString: String = ""
    
    @State fileprivate var searchResults: [FriendModel] = []
//    [UserModel(email: "", firstName: "", lastName: "", verified: true, deviceToken: "")]
    
    @Binding var showSheet: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(searchResults, id: \.email) { result in
                        FriendListItemView(
                            friend: result,
                            onDelete: {
                                Task {
                                    await onDelete(result.userID)
                                }
                            },
                            onAdd: {
                                Task {
                                    print("adding? \(result.userID)")
                                    await onAdd(result.userID)
                                }
                            }
                        )
                        .listRowInsets(EdgeInsets(top: 6,
                                                  leading: 6,
                                                  bottom: 6,
                                                  trailing: 6)
                        )
                    }
                    
                    if (searchResults.isEmpty) {
                        FriendListItemView()
                            .redacted(reason: .placeholder)
                            .listRowInsets(EdgeInsets(top: 6,
                                                    leading: 6,
                                                    bottom: 6,
                                                    trailing: 6)
                            )
                    }
                }
            }
            .navigationTitle("Add New Friends")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    //action
                    showSheet = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }

            }
            
        }
        .searchable(text: $queryString)
        .onChange(of: queryString) { newValue in
            Task {
                let searchResults = await onSearch(newValue)
                self.searchResults = searchResults
            }
        }
    }
}

struct AddNewFriendsView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewFriendsView(onSearch: {search in return [FriendModel(userID: "", firstName: "", lastName: "", colorScheme: 1, status: 0, email: "")]}, showSheet: .constant(true))
    }
}
