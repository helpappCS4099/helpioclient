//
//  AddNewFriendsView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 22/02/2023.
//

import SwiftUI

struct AddNewFriendsView: View {
    
    @State var queryString: String = ""
    
    @State fileprivate var searchResults: [UserModel] = []
//    [UserModel(email: "", firstName: "", lastName: "", verified: true, deviceToken: "")]
    
    @Binding var showSheet: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(searchResults, id: \.email) { result in
                        FriendListItemView()
                    }
                    
                    if (searchResults.isEmpty) {
                        FriendListItemView().redacted(reason: .placeholder)
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
    }
}

struct AddNewFriendsView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewFriendsView(showSheet: .constant(true))
    }
}
