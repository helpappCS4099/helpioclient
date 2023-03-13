//
//  FriendListItemView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 22/02/2023.
//

import SwiftUI

struct FriendListItemView: View {
    
    var friend: FriendModel?
    
    var onDelete: () -> Void = {}
    var onAdd: () -> Void = {}
    
    let diameter: CGFloat = 65    //for circle
    
    @State var showRemoveFriend: Bool = false
    
    var body: some View {
        HStack {
            //circle
            ZStack {
                Text((friend?.firstName[0].uppercased() ?? "N") + (friend?.lastName[0].uppercased() ?? "S"))
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.3), radius: 5)
            }
            .frame(width: diameter, height: diameter)
            .background(friend != nil ? AccountGradient.getByID(id: friend!.colorScheme) : LinearGradient(colors: [Color(uiColor: .tertiarySystemFill), .gray], startPoint: .topLeading, endPoint: .bottomTrailing))
            .clipShape(Circle())
            
            //name email
            VStack(alignment: .leading) {
                
                Text((friend?.firstName ?? "Name") + " " + (friend?.lastName ?? "Surname"))
                    .font(.body)
                    .fontWeight(.medium)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(2)
                    .truncationMode(.tail)
                
                Text(friend?.email.staprefix() ?? "un303")
                    .font(.subheadline)
                    .fontWeight(.light)
                
                Spacer()
            }
            .frame(height: diameter)
            
            Spacer()
            
            ZStack {
                //button
                switch friend?.status {
                case 0:
                    Button {
                        onAdd()
                    } label: {
                        Text("\(Image(systemName: "person.fill.badge.plus")) Add")
                            .font(.body)
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    .tint(.sysblue)
                case 1:
                    Button {
                        //action
                        showRemoveFriend = true
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 25))
                    }
                    .buttonStyle(.borderless)
                    .tint(.gray)
                case 2:
                    Button {
                        onDelete()
                    } label: {
                        Text("\(Image(systemName: "person.fill.badge.minus")) Cancel")
                            .font(.body)
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    .tint(.orange)
                case 3:
                    HStack {
                        Button {
                            onAdd()
                        } label: {
                            Text("\(Image(systemName: "plus")) Accept")
                                .font(.body)
                                .fixedSize(horizontal: true, vertical: false)
                        }
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        .tint(.green)
                        
                        Button {
                            onDelete()
                        } label: {
                            Image(systemName: "trash.fill")
                                .font(.body)
                        }
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        .tint(.red)
                    }
                default:
                    EmptyView()
                }
            }
            .opacity(friend == nil ? 0 : 1)
        }
        .confirmationDialog("Remove friend?", isPresented: $showRemoveFriend, actions: {
            Button("Remove", role: .destructive, action: {
                onDelete()
            })
        })
        .padding(5)
        .if(friend == nil) { view in
            view.redacted(reason: .placeholder)
        }
    }
}

struct FriendListItemView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            List {
                FriendListItemView()
                    .previewLayout(PreviewLayout.sizeThatFits)
                    .previewDisplayName("Are Friends")
            }
            
            List {
                FriendListItemView()
                    .previewLayout(PreviewLayout.sizeThatFits)
                    .previewDisplayName("You send request")
            }
            
            List {
                FriendListItemView()
                    .previewLayout(PreviewLayout.sizeThatFits)
                    .previewDisplayName("They sent request")
            }
        }
    }
}
