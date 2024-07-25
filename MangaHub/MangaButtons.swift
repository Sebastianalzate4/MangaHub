//
//  MangaButtons.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/07/24.
//

import Foundation
import SwiftUI


extension View {
    
    // Modificador de apariencia de un botón y cambia el color si el botón es seleccionado.
    // Authors, Website, Categories.
    func mangaHubButtonSelected(isSelected: Bool) -> some View {
        self
            .padding()
            .font(.system(.headline, design: .rounded))
            .bold()
            .foregroundColor(Color.white)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color.gray : Color.mangaHubColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    // Modificador para los botones de la 'OnboardingView', Add to Favorites de la 'MangaDetailView' y Add New de la 'PurchasedVolumesView'.
    func mangaHubButton(color: Color) -> some View {
        self
            .font(.title3)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .foregroundColor(.white)
            .bold()
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
    }
}

