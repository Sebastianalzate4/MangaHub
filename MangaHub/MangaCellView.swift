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
        HStack(alignment: .center) {
            
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
                
                Text("**Status:** \(manga.formattedStatus)")
                
            }
        }
    }
}

#Preview {
    MangaCellView(manga: .preview)
}
