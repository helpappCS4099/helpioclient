//
//  RootView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 02/02/2023.
//

import SwiftUI

struct RootView: View {
    
    init(appState: AppState, interactors: Interactors) {
        self.appState = appState
        self.interactors = interactors
    }
    
    @State var appState: AppState
    let interactors: Interactors
    
    var body: some View {
        ZStack {
            if !appState.userIsLoggedIn {
                AuthRootView().environmentObject(appState)
            } else {
                ContentView().environmentObject(appState)
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(appState: AppState(), interactors: Interactors())
    }
}
