//
//  DI.swift
//  Help App
//
//  Created by Artem Rakhmanov on 16/02/2023.
//

import Foundation
import Combine

class DI: ObservableObject {
    let appState: AppState
    let interactors: Interactors
    
    init(appState: AppState, interactors: Interactors) {
        self.appState = appState
        self.interactors = interactors
    }
}
