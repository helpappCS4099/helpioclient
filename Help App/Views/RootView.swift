//
//  RootView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 02/02/2023.
//

import SwiftUI

struct RootView: View {
    
    init(dependencies: DI) {
        self.interactors = dependencies.interactors
    }
    
    @EnvironmentObject var appState: AppState
    let interactors: Interactors
    
    var body: some View {
        ZStack {
            if !appState.userIsLoggedIn {
                AuthRootView(sessionInteractor: interactors.sessionInteractor)
                    .environmentObject(appState.auth)
            } else {
                ContentView().environmentObject(appState)
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    
    static var previews: some View {
        let env = Environment.bootstrapLoggedIn(currentPage: .friends)
        
        RootView(dependencies: env.diContainer)
            .environmentObject(env.diContainer.appState)
    }
}
