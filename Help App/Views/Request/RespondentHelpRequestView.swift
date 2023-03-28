//
//  RespondentHelpRequestView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 24/03/2023.
//

import SwiftUI

struct RespondentHelpRequestView: View {
    
    @EnvironmentObject var appState: AppState
    
    var helpInteractor: HelpInteractor
    @StateObject var helpRequest: HelpRequestState
    
    var body: some View {
        Button {
            appState.helpRequestID = ""
            appState.showHelpRequest = false
        } label: {
            Text("Reset UD")
        }
        .buttonStyle(.bordered)
        .controlSize(.large)

    }
}

struct RespondentHelpRequestView_Previews: PreviewProvider {
    static var previews: some View {
        
        let di = Environment.bootstrapLoggedIn(currentPage: .home).diContainer
        RespondentHelpRequestView(
            helpInteractor: di.interactors.help,
            helpRequest: HelpRequestState())
            .environmentObject(di.appState)
    }
}
