//
//  FriendFormItemView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 13/03/2023.
//

import SwiftUI

struct FriendFormItemView: View {
    
    var friend: FriendModel
    
    let diameter: CGFloat = 65    //for circle
    
    @Binding var selectedFriends: [String]
    
    var onSelect: (String) -> Void = {_ in}
    var onRemove: (String) -> Void = {_ in}
    
    @State var tapped: Bool = false
    
    var body: some View {
        HStack {
            //circle
            ZStack {
                Text(friend.firstName[0].uppercased() + friend.lastName[0].uppercased())
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.3), radius: 5)
            }
            .frame(width: diameter, height: diameter)
            .background(AccountGradient.getByID(id: friend.colorScheme))
            .clipShape(Circle())
            
            //name email
            VStack(alignment: .leading) {
                
                Text(friend.firstName + " " + friend.lastName)
                    .font(.body)
                    .fontWeight(.medium)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(2)
                    .truncationMode(.tail)
                
                Text(friend.email.staprefix())
                    .font(.subheadline)
                    .fontWeight(.light)
                
                Spacer()
                
//                Divider()
//                    .frame(maxWidth: .infinity)
            }
            .frame(height: diameter)
            
            Spacer()
            
            ZStack {
                Circle()
                    .stroke(Color.adaptiveBlack, lineWidth: 2)
                    .frame(width: 24, height: 24)
                
                if selectedFriends.contains(friend.userID) {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.adaptiveBlack)
                        .frame(width: 20, height: 20)
                        .transition(.opacity)
                } else {
                    EmptyView()
                }
            }
        }
        .contentShape(Rectangle())
        .opacity(tapped ? 0.6 : 1)
        .foregroundColor(tapped ? .gray : .none)
        .onTapGesture {
            tapped = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                tapped = false
                //action
                if selectedFriends.contains(friend.userID) {
                    onRemove(friend.userID)
                } else {
                    onSelect(friend.userID)
                }
            }
        }

    }
}

struct FriendFormItemView_Previews: PreviewProvider {
    
    static var previews: some View {
        FriendFormItemView(
            friend: FriendModel(userID: "jskldsjldjlsd",
                                firstName: "Bob",
                                lastName: "Roberts",
                                colorScheme: 1,
                                status: 1,
                                email: "br202@st-andrews.ac.uk"),
            selectedFriends: .constant([]))
    }
}
