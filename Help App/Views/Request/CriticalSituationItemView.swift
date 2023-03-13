//
//  CriticalSituationItemView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 13/03/2023.
//

import SwiftUI

struct CriticalSituationItemView: View {
    
    var situation: CriticalSituation = .trauma
    
    var body: some View {
        GeometryReader { reader in
            VStack(alignment: .leading, spacing: 16) {
                
                HStack(alignment: .center) {
                    situation.image
                        .frame(width: reader.size.width / 2)
                }
                .frame(width: reader.size.width)
                .padding(.top, 20)
                
                Spacer()
                
                HStack {
                    Text(situation.rawValue)
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                }
                .padding([.bottom, .leading], 10)
            }
            .frame(width: reader.size.width, height: reader.size.height)
            .shadow(color: .black.opacity(0.3), radius: 5)
            .background(situation.color)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

struct CriticalSituationItemView_Previews: PreviewProvider {
    static var previews: some View {
        CriticalSituationItemView()
    }
}
