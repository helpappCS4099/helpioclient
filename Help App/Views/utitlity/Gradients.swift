//
//  Gradients.swift
//  Help App
//
//  Created by Artem Rakhmanov on 01/02/2023.
//

import SwiftUI

class CustomGradients {
    static let greenAsh: LinearGradient = LinearGradient(colors: [.avatarGradientStart, .greenAsh], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let lavender: LinearGradient = LinearGradient(colors: [.avatarGradientStart, .lavender], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let pear: LinearGradient = LinearGradient(colors: [.avatarGradientStart, .pear], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let aquarium: LinearGradient = LinearGradient(colors: [.avatarGradientStart, .aquarium], startPoint: .topLeading, endPoint: .bottomTrailing)
    static let ochre: LinearGradient = LinearGradient(colors: [.avatarGradientStart, .ochre], startPoint: .topLeading, endPoint: .bottomTrailing)
}

enum AccountGradient: CaseIterable {
    
    static func getByID(id: Int) -> LinearGradient {
        switch id {
        case 0:
            return CustomGradients.greenAsh
        case 1:
            return CustomGradients.aquarium
        case 2:
            return CustomGradients.pear
        case 3:
            return CustomGradients.ochre
        case 4:
            return CustomGradients.lavender
        default:
            return CustomGradients.greenAsh
        }
    }
    
    var id: Int {
        get  {
            switch self {
            case .greenAsh:
                return 0
            case .aquarium:
                return 1
            case .pear:
                return 2
            case .ochre:
                return 3
            case .lavender:
                return 4
            }
        }
    }
    
    var gradient: LinearGradient {
        get  {
            switch self {
            case .greenAsh:
                return CustomGradients.greenAsh
            case .aquarium:
                return CustomGradients.aquarium
            case .pear:
                return CustomGradients.pear
            case .ochre:
                return CustomGradients.ochre
            case .lavender:
                return CustomGradients.lavender
            }
        }
    }

    
    case greenAsh, aquarium, pear, ochre, lavender
}
