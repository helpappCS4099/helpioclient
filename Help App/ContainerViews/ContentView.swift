//
//  ContentView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 31/01/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            CategoryIcons.trauma
                .frame(width: 200, height: 200)
                .background(AccountGradients.aquarium)
            
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
