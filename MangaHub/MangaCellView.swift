//
//  MangaCellView.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/07/24.
//

import SwiftUI

struct MangaCellView: View {
    
    var manga: Manga
    
    var body: some View {
        HStack(alignment: .top) {
            
            MangaPosterView(manga: manga, size: .small)
            
            VStack(alignment: .leading) {
                Text(manga.title)
                    .mangaTextModifier()
                    .padding(.trailing)
                
                Text("\(manga.authors.first?.firstName ?? "") \(manga.authors.first?.lastName ?? "")")
                    .font(.footnote)
                    .foregroundStyle(Color.secondary)
                
                Text("**Score:** \(manga.formattedScore)")
                
                Text("**Year:** \(manga.formattedStartDate)")
                
            }
        }
    }
}

#Preview {
    MangaCellView(manga: .preview)
}
