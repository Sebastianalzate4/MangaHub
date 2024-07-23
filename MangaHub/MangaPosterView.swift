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
                .frame(width: frameWidth(for: size), height: frameHeight(for: size))
        } placeholder: {
            ProgressView()
                .controlSize(.extraLarge)
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .frame(width: frameWidth(for: size), height: frameHeight(for: size))
        }
    }
    
    // Funciones para determinar el tamaño/frame de la imagen: 
    
    private func frameWidth(for size: PosterSize) -> CGFloat {
        switch size {
        case .small:
            return 100
        case .medium:
            return 200
        case .large:
            return 350
        }
    }
    
    private func frameHeight(for size: PosterSize) -> CGFloat {
        switch size {
        case .small:
            return 150
        case .medium:
            return 200
        case .large:
            return 350
        }
    }
}

#Preview {
    MangaPosterView(manga: .preview)
}

enum PosterSize {
    case small
    case medium
    case large
}
