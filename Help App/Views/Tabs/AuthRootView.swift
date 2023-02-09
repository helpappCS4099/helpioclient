//
//  AuthRootView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 02/02/2023.
//

import SwiftUI

struct AuthRootView: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            Text("auth")
        }
    }
}

struct AuthRootView_Previews: PreviewProvider {
    static var previews: some View {
        AuthRootView().environmentObject(AppState())
    }
}
