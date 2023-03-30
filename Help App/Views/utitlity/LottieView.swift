//
//  LottieView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 30/03/2023.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    
    var animationView = LottieAnimationView(name: "emailAnimation")
    var filename = "emailAnimation"
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
//        let animation = Animation.named(filename)
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        animationView.loopMode = .loop
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}
