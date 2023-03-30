//
//  VerifyEmailView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 16/02/2023.
//

import SwiftUI
import Lottie

extension AuthRootView {
    func verifyEmail() -> some View {
        VStack {
            LottieView()
                .frame(width: bounds.width * 0.6)
        }
    }
}
