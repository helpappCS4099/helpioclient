//
//  AppContentEnums.swift
//  Help App
//
//  Created by Artem Rakhmanov on 13/03/2023.
//

import SwiftUI

enum CriticalSituation: String, CaseIterable, Identifiable {
    var id: UUID {
        get {
            return UUID()
        }
    }
    
    
    case trauma = "Trauma"
    case assault = "Assault"
    case stalking = "Stalking"
    case intoxication = "Intoxication"
    case spiking = "Spiking"
    
    var color: Color {
        get {
            switch self {
            case .trauma:
                return .electric
            case .assault:
                return .stop
            case .stalking:
                return .cherry
            case .intoxication:
                return .altyn
            case .spiking:
                return .fog
            }
        }
    }
    
    var categoryCode: Int {
        get {
            switch self {
            case .trauma:
                return 0
            case .assault:
                return 1
            case .stalking:
                return 2
            case .intoxication:
                return 3
            case .spiking:
                return 4
            }
        }
    }
    
    var image: Image {
        get {
            switch self {
            case .trauma:
                return (CategoryIcons.trauma)
            case .assault:
                return (CategoryIcons.assault)
            case .stalking:
                return (CategoryIcons.stalking)
            case .intoxication:
                return (CategoryIcons.intoxication)
            case .spiking:
                return (CategoryIcons.spiking)
            }
        }
    }
}

enum HelpRequestFormStage: Int {
    case category = 1
    case friends = 2
    case note = 3
    case none = 0
}
