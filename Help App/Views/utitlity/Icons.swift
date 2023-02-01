//
//  CategoryIcons.swift
//  Help App
//
//  Created by Artem Rakhmanov on 01/02/2023.
//

import SwiftUI

class CategoryIcons {
    static let trauma: some View = Image(systemName: "bandage.fill").resizable().foregroundColor(.white).aspectRatio(contentMode: .fit)
    static let assault: some View = Image(systemName: "exclamationmark.triangle.fill").resizable().foregroundColor(.white).aspectRatio(contentMode: .fit)
    static let stalking: some View = Image(systemName: "eye.trianglebadge.exclamationmark.fill").resizable().foregroundColor(.white).aspectRatio(contentMode: .fit)
    static let intoxication: some View = Image(systemName: "pills.fill").resizable().foregroundColor(.white).aspectRatio(contentMode: .fit)
    static let spiking: some View = Image("spikingIcon").resizable().aspectRatio(contentMode: .fit)
}
