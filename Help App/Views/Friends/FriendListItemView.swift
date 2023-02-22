//
//  FriendListItemView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 22/02/2023.
//

import SwiftUI

struct FriendListItemView: View {
    
    var firstName: String = "Artem"
    var lastName: String = "Rakhmanov"
    var email: String = "ar303@st-andrews.ac.uk"
    var friendStatus: Int = 1
    var gradient: LinearGradient = CustomGradients.greenAsh
    
    let diameter: CGFloat = 65    //for circle
    
    var body: some View {
        HStack {
            //circle
            ZStack {
                Text(firstName[0].uppercased() + lastName[0].uppercased())
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.3), radius: 5)
            }
            .frame(width: diameter, height: diameter)
            .background(gradient)
            .clipShape(Circle())
            
            //name email
            VStack(alignment: .leading) {
                
                Text(firstName + " " + lastName)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text(email.staprefix())
                    .font(.subheadline)
                    .fontWeight(.light)
                
                Spacer()
            }
            .frame(height: diameter)
            
            Spacer()
            
            //button
            switch friendStatus {
            case 1:
                Button {
                    //action
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 25))
                }
                .buttonStyle(.borderless)
                .tint(.gray)
            case 2:
                Button {
                    //action
                } label: {
                    Text("\(Image(systemName: "person.fill.badge.minus")) Cancel")
                        .font(.body)
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .tint(.orange)
            case 3:
                Button {
                    //action
                } label: {
                    Text("\(Image(systemName: "plus")) Accept")
                        .font(.body)
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .tint(.green)
                
                Button {
                    //action
                } label: {
                    Image(systemName: "trash.fill")
                        .font(.body)
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .tint(.red)
            default:
                EmptyView()
            }
        }
        .padding(5)
    }
}

struct FriendListItemView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            FriendListItemView(friendStatus: 1)
                .previewLayout(PreviewLayout.sizeThatFits)
                .previewDisplayName("Are Friends")
            
            FriendListItemView(friendStatus: 2)
                .previewLayout(PreviewLayout.sizeThatFits)
                .previewDisplayName("You send request")
            
            FriendListItemView(friendStatus: 3)
                .previewLayout(PreviewLayout.sizeThatFits)
                .previewDisplayName("They sent request")
        }
    }
}
