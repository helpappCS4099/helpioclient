//
//  PermissionDescription.swift
//  Help App
//
//  Created by Artem Rakhmanov on 21/02/2023.
//

import Foundation

enum PermissionDescription: Comparable, CaseIterable{
    
    case notifications, location
    
    var title: String {
        get {
            switch self {
            case .notifications:
                return "Critical Notifications"
            case .location:
                return "Background Location"
//            case .microphone:
//                return "Microphone"
            }
        }
    }
    
    var description: String {
        get {
            switch self {
            case .notifications:
                return "If your friend requests help, this makes possible for you to  receive notifications even if your phone is on silent."
            case .location:
                return "Share location with your friends in critical situations. The data is encrypted on the phone and is only visible to you or your friends."
//            case .microphone:
//                return "Share location with your friends in critical situations. The data is encrypted on the phone and is only visible to you or your friends."
            }
        }
    }
    
    var imgName: String {
        get {
            switch self {
            case .notifications:
                return "app.badge"
            case .location:
                return "location.viewfinder"
//            case .microphone:
//                return ""
            }
        }
    }
}
