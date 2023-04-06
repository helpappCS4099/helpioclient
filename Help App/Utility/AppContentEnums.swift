//
//  AppContentEnums.swift
//  Help App
//
//  Created by Artem Rakhmanov on 13/03/2023.
//

import SwiftUI

enum CriticalSituation: String, CaseIterable, Identifiable {
    
    case trauma = "Trauma"
    case assault = "Assault"
    case stalking = "Stalking"
    case intoxication = "Intoxication"
    case spiking = "Spiking"
    
    init(code: Int) {
        switch code {
        case 0: self = .trauma
        case 1: self = .assault
        case 2: self = .stalking
        case 3: self = .intoxication
        case 4: self = .spiking
        default: self = .trauma
        }
    }
    
    var id: UUID {
        get {
            return UUID()
        }
    }
    
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

enum RespondentStatus: Int {
    
    case notified = 0
    case accepted = 1
    case ontheway = 2
    case rejected = -1
    
    var statusString: String {
        get {
            switch self.rawValue {
            case 0:
                return "Notified"
            case 1:
                return "Accepted"
            case 2:
                return "On the way"
            case -1:
                return "Rejected"
            default:
                return "Notified"
            }
        }
    }
    
    var glyphSystemName: String {
        get {
            switch self.rawValue {
            case 0:
                return "arrow.up.message.fill"
            case 1:
                return "checkmark.circle.fill"
            case 2:
                return "figure.walk.circle.fill"
            case -1:
                return "xmark.circle.fill"
            default:
                return "arrow.up.message.fill"
            }
        }
    }
    
    var color: Color {
        get {
            switch self.rawValue {
            case 0:
                return Color.tertblue
            case 1:
                return Color.green
            case 2:
                return Color.green
            case -1:
                return Color.red
            default:
                return Color.tertblue
            }
        }
    }
    
    var shadowColor: Color {
        get {
            switch self.rawValue {
            case 0:
                return .clear
            case 1:
                return .clear
            case 2:
                return .green
            case -1:
                return .clear
            default:
                return .tertblue
            }
        }
    }
}
