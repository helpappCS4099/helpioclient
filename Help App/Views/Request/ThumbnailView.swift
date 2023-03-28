//
//  ThumbnailView.swift
//  Help App
//
//  Created by Artem Rakhmanov on 27/03/2023.
//

import SwiftUI

struct ThumbnailView: View {
    var body: some View {
        Text("Thumbnail")
            .padding(30)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct ThumbnailView_Previews: PreviewProvider {
    static var previews: some View {
        ThumbnailView()
    }
}
