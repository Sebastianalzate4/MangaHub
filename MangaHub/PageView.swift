//
//  PageView.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 15/07/24.
//

import SwiftUI

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
