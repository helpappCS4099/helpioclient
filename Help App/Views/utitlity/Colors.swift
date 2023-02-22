//
//  Colors.swift
//  Help App
//
//  Created by Artem Rakhmanov on 01/02/2023.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

//sys colors
extension Color {
    static let sysblue = Color("System Blue")
    static let tertblue = Color("Tertiary Blue")
    static let adaptiveBlack = Color("Adaptive Black")
}

//Avatar Gradient Colors
extension Color {
    static let greenAsh = Color("Green Ash")
    static let lavender = Color("Lavender")
    static let ochre = Color("Ochre")
    static let pear = Color("Pear")
    static let aquarium = Color("Aquarium")
    static let avatarGradientStart = Color("avatarGradientStart")
}

//situation categories colors
extension Color {
    static let electric = Color("Electric")
    static let altyn = Color("Altyn")
    static let cherry = Color("Cherry")
    static let fog = Color("Fog")
    static let stop = Color("Stop")
}



