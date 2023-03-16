//
//  CriticalSituationItemView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 13/03/2023.
//

import SwiftUI

struct CriticalSituationItemView: View {
    
    var onSelect: (CriticalSituation) -> Void = {_ in}
    
    var situation: CriticalSituation = .trauma
    
    @State var tapped: Bool = false
    @State var longPressDuration: CGFloat = 0
    @GestureState var press = false
    
    //calculate icon size responsively
    func imageSize(_ container: CGSize) -> CGFloat {
        let idealWidth = container.width / 2
        let maxHeight = container.height / 2
        return idealWidth < maxHeight ? idealWidth : maxHeight
    }
    
    var body: some View {
        GeometryReader { reader in
            VStack(alignment: .leading, spacing: 0) {
                
                HStack(alignment: .center) {
                    situation.image
                        .resizable()
                        .foregroundColor(.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: imageSize(reader.size), height: imageSize(reader.size))
                }
                .frame(width: reader.size.width, height: imageSize(reader.size))
                .padding(.top, 20)
                
                Spacer()
                
                HStack {
                    Text(situation.rawValue)
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                }
                .padding([.leading, .bottom], 10)
            }
            .frame(width: reader.size.width, height: reader.size.height)
            .shadow(color: .black.opacity(0.3), radius: 5)
            .background(situation.color)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .scaleEffect(tapped ? 0.95 : 1)
            .scaleEffect(press ? 0.8 : 1)
            .opacity(tapped ? 0.7 : 1)
            .opacity(press ? 0.7 : 1)
            .onTapGesture {
                tapped = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    tapped = false
                    onSelect(situation)
                }
            }
//            .simultaneousGesture(
//                TapGesture().onEnded({
//                    tapped = true
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                        tapped = false
//                    }
//                })
//            )
            .simultaneousGesture(
                LongPressGesture(minimumDuration: 3)
                    .onEnded({ value in
                    
                    })
                    .updating($press, body: { currentState, gestureState, transaction in
                        gestureState = currentState
                    })
            )
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: tapped)
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: press)
    }
}

struct CriticalSituationItemView_Previews: PreviewProvider {
    static var previews: some View {
        CriticalSituationItemView()
    }
}
