//
//  ContentView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 31/01/2023.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var appState: AppState
    var interactors: Interactors
    
    func onLogOut() {
        Task {
            await interactors.session.logOut()
        }
    }
        
    var body: some View {
        TabView(selection: $appState.currentPage) {
            HomeTabView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(AppTab.home)
            
            FriendsTabView(userInteractor: interactors.user)
                .tabItem {
                    Label("Friends", systemImage: "person.2.fill")
                }
                .tag(AppTab.friends)
            
            AccountTabView(onLogOut: onLogOut)
                .tabItem {
                    Label("Account", systemImage: "person.circle.fill")
                }
                .tag(AppTab.account)
        }
        .onAppear {
            //set the tab bar appearance to default
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        let env = Environment.bootstrapLoggedIn(currentPage: .friends)
        
        ContentView(interactors: env.diContainer.interactors)
            .environmentObject(env.diContainer.appState)
    }
}
