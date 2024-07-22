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
        HStack {
 
            MangaPosterView(manga: manga)
                        
            VStack(alignment: .leading) {
                Text(manga.title)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
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
