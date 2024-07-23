//
//  MangaUnavailableView.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 15/07/24.
//

import SwiftUI

struct MangaUnavailableView: View {
    
    var systemName: String
    var title: String
    var subtitle: String
    
    var body: some View {
        
        VStack {
            Image(systemName: systemName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundColor(.mangaHubColor)
            Text(title)
                .bold()
                .font(.title3)
            Text(subtitle)
                .foregroundColor(.secondary)
                .font(.callout)
                .bold()
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    MangaUnavailableView(systemName: "star.slash.fill", title: "This is the Title", subtitle: "And this would be the subtitle")
}
