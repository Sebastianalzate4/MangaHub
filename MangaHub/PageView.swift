//
//  PageView.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 15/07/24.
//

import SwiftUI

// Vista que contiene la estructura del Onboarding de la app. La imagén, el título y la descripción. Recibe estos valores a partir de la estructura 'Page'.

struct PageView: View {
    
    var page: Page
    
    var body: some View {
        VStack {
            Image(page.imageName)
                .resizable()
                .scaledToFit()
                .padding()
            
            Text(page.title)
                .font(.largeTitle)
                .bold()
                .padding()
            
            Text(page.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}

#Preview {
    PageView(page: Page.pages[1])
}
