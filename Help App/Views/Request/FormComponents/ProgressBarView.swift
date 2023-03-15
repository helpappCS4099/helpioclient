//
//  ProgressBarView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 13/03/2023.
//

import SwiftUI

struct ProgressBarView: View {
    
    @Binding var progress: HelpRequestFormStage
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color(uiColor: .tertiarySystemFill)
            
            //one side pill
            ZStack {
                
                Rectangle()
                    .overlay(
                        LinearGradient(colors: [.sysblue, .tertblue], startPoint: .leading, endPoint: .trailing)
                    )
                    .frame(width: (bounds.width / CGFloat(3) * CGFloat(progress.rawValue)), height: 40)
                
                Text(String(Int(Double(progress.rawValue * 100 / 3).rounded())) + "%")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
            }
            .cornerRadius(progress == .note ? 0 : 40, corners: [.bottomRight, .topRight])
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 5, y:0)
        }
        .frame(width: bounds.width, height: 40)
        .clipShape(Rectangle())
        .animation(.easeInOut, value: progress)
    }
}

struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBarView(progress: .constant(.category))
    }
}
