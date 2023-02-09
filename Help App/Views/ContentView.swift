//
//  ContentView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 31/01/2023.
//

import SwiftUI

struct ContentView: View {
        
    var body: some View {
        TabView {
            HomeTabView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            FriendsTabView()
                .tabItem {
                    Label("Friends", systemImage: "person.2.fill")
                }
            
            AccountTabView()
                .tabItem {
                    Label("Account", systemImage: "person.circle.fill")
                }
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
        ContentView()
    }
}
