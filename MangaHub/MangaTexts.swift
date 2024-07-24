//
//  MangaTexts.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 23/07/24.
//

import Foundation
import SwiftUI


extension View {
    
    // Text de la CellView, Grid de la MangaListView.
    func mangaTextModifier() -> some View {
        self
            .font(.system(.headline, design: .rounded))
            .foregroundColor(Color.white)
            .multilineTextAlignment(.center)
            .lineLimit(1)
            .padding(.horizontal, 8)
            .frame(maxWidth: 200)
            .frame(height: 25)
            .background(Color.mangaHubColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay{
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 0.5)
            }
    }
}



