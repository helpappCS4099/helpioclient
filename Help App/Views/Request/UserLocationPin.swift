//
//  UserLocationPin.swift
//  Help App
//
//  Created by Artem Rakhmanov on 29/03/2023.
//

import SwiftUI
import MapKit

struct UserLocationPin: View {
    
    var locationPoint: AnnotationItem
    
    @Binding var region: MKCoordinateRegion
    @Binding var distance: String
    @Binding var showDistanceMessage: Bool
    
    var victimView = true
    var isOwner = false
    
    @State var animate = false
    
    var body: some View {
        
        ZStack {
            VStack(spacing: -3) {
                ZStack(alignment: .center) {
                    
                }
                .frame(width: 50,height: 50)
                .clipShape(Circle())
                
                Image(systemName: "arrowtriangle.down.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 10,height: 10)
            }
            
            Rectangle()
                .foregroundColor(.clear)
                .background(isOwner ? LinearGradient(colors: [.red], startPoint: .top, endPoint: .bottom) : AccountGradient.getByID(id: locationPoint.colorScheme))
                .mask {
                    VStack(spacing: -3) {
                        Circle()
                            .frame(width: 50,height: 50)
                        Image(systemName: "arrowtriangle.down.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 10,height: 10)
                    }
                }
                .zIndex(4)
                .overlay {
                    
                    ZStack {
                        if isOwner {
                            ZStack {
                                Circle().fill(.red.opacity(0.20)).frame(width: 60, height: 60).scaleEffect(self.animate ? 1 : 0)
                                Circle().fill(.red.opacity(0.15)).frame(width: 70, height: 70).scaleEffect(self.animate ? 1 : 0)
                                Circle().fill(.red.opacity(0.10)).frame(width: 80, height: 80).scaleEffect(self.animate ? 1 : 0)
                            }
                            .onAppear { self.animate.toggle() }
                            .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animate)
                        }
                        
                        Text(locationPoint.thumbnailLetters)
                            .font(.system(size: 20, design: .rounded))
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(7)
                            .frame(maxHeight: .infinity, alignment: .center)
                            .zIndex(5)
                            
                    }
                    .offset(y: -4)
                }
                .shadow(color: .black.opacity(0.15), radius: 10)
            
            
        }
        .frame(width: 100,height: 100)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 1)) {
                region = locationPoint.getMKMapRectRegion()
                if victimView || isOwner {
                    distance = locationPoint.getDistanceToUser()
                    showDistanceMessage = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        showDistanceMessage = false
                    }
                }
            }
        }
    }
}
