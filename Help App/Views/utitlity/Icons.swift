//
//  CategoryIcons.swift
//  Help App
//
//  Created by Artem Rakhmanov on 01/02/2023.
//

import SwiftUI

struct CategoryIcons {
    static let trauma: some View = Image(systemName: "bandage.fill").resizable().foregroundColor(.white).aspectRatio(contentMode: .fit)
    static let assault: some View = Image(systemName: "exclamationmark.triangle.fill").resizable().foregroundColor(.white).aspectRatio(contentMode: .fit)
    static let stalking: some View = Image(systemName: "eye.trianglebadge.exclamationmark.fill").resizable().foregroundColor(.white).aspectRatio(contentMode: .fit)
    static let intoxication: some View = Image(systemName: "pills.fill").resizable().foregroundColor(.white).aspectRatio(contentMode: .fit)
    static let spiking: some View = Image("spikingIcon").resizable().aspectRatio(contentMode: .fit)
}

enum CriticalSituation: String, CaseIterable {
    
    case trauma = "Trauma"
    case assault = "Assault"
    case stalking = "Stalking"
    case intocication = "Intoxication"
    case spiking = "Spiking"
    
    var color: Color {
        get {
            switch self {
            case .trauma:
                return .electric
            case .assault:
                return .altyn
            case .stalking:
                return .cherry
            case .intocication:
                return .fog
            case .spiking:
                return .stop
            }
        }
    }
    
    var image: some View {
        get {
            switch self {
            case .trauma:
                return AnyView(CategoryIcons.trauma)
            case .assault:
                return AnyView(CategoryIcons.assault)
            case .stalking:
                return AnyView(CategoryIcons.stalking)
            case .intocication:
                return AnyView(CategoryIcons.intoxication)
            case .spiking:
                return AnyView(CategoryIcons.spiking)
            }
        }
    }
}
