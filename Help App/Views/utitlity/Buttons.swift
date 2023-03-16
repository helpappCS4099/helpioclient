//
//  Buttons.swift
//  Help App
//
//  Created by Artem Rakhmanov on 02/02/2023.
//

import SwiftUI

struct LargeRedButton: ButtonStyle {
    
    let hasShadow: Bool
    
    init(hasShadow: Bool = false) {
        self.hasShadow = hasShadow
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: 75)
            .padding()
            .background(.red)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: hasShadow ? Color.red.opacity(0.5) : .clear, radius: 5, x: 0, y: 2)
            .shadow(color: hasShadow ? Color.red.opacity(0.3) : .clear, radius: 20, x: 0, y: 10)
            .opacity(configuration.isPressed ? 0.6 : 1)
    }
}

struct FormAccessibleButton: ButtonStyle {
    
    @Binding var isRed: Bool
    let isNotched: Bool
    
    init(isRed: Binding<Bool>) {
        self._isRed = isRed
        isNotched = isNotchedIphone()
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: bounds.width - 10, height: 150)
            .background(isRed ? .red : .sysblue)
            .foregroundColor(.white)
            .cornerRadius(16, corners: [.topRight, .topLeft])
            .cornerRadius(isNotched ? 39 : 16, corners: [.bottomRight, .bottomLeft])
            .opacity(configuration.isPressed ? 0.6 : 1)
    }
}

struct SystemLargeButton: ButtonStyle {
    
    let hasShadow: Bool
    
    init(hasShadow: Bool = false) {
        self.hasShadow = hasShadow
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: 40)
            .padding()
            .background(Color.sysblue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: hasShadow ? Color.sysblue.opacity(0.5) : .clear, radius: 5, x: 0, y: 2)
            .shadow(color: hasShadow ? Color.sysblue.opacity(0.3) : .clear, radius: 20, x: 0, y: 10)
            .opacity(configuration.isPressed ? 0.6 : 1)
    }
}
