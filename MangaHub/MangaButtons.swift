//
//  MangaButtons.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/07/24.
//

import Foundation
import SwiftUI

//extension View {
//    func mangaHubButton() -> some View {
//        self
//            .frame(maxWidth: .infinity)
//            .frame(height: 40)
//            .foregroundColor(.white)
//            .background(
//                LinearGradient(colors: [Color.yellow, Color.orange, Color.yellow], startPoint: .leading, endPoint: .trailing))
//            .clipShape(Capsule())
//            .padding(.horizontal)
//    }
//}


// Identifica el botón seleccionado en la tab de 'Categories' para cambiarle el color. 
extension View {
    func mangaHubButtonCategories(isSelected: Bool) -> some View {
        self
            .padding()
            .font(.system(.headline, design: .rounded))
            .bold()
            .foregroundColor(Color.white)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color.gray : Color.mangaHubColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black, lineWidth: 0.5))
    }
}


