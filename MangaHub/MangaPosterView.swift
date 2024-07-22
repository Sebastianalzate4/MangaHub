//
//  MangaPosterView.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/07/24.
//

import SwiftUI

struct MangaPosterView: View {
    var manga: Manga
    var size: PosterSize = .small
    
    var body: some View {
        AsyncImage(url: manga.mainPictureURL) { image in
            image
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .frame(width: size == .small ? 150 : 200, height: size == .small ? 150 : 200)
        } placeholder: {
            ProgressView()
                .controlSize(.extraLarge)
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .frame(width: size == .small ? 150 : 200, height: size == .small ? 150 : 200)
        }
    }
}

#Preview {
    MangaPosterView(manga: .preview)
}

enum PosterSize {
    case small
    case large
}
