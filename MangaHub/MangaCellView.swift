//
//  MangaCellView.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/07/24.
//

import SwiftUI

struct MangaCellView: View {
    
    var manga: Manga
//    let deviceType = UIDevice.current.userInterfaceIdiom
    
    var body: some View {
        HStack {
 
            MangaPosterView(manga: manga)
                        
            VStack(alignment: .leading) {
                Text(manga.title)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .padding(.horizontal, 8)
//                    .frame(maxWidth: deviceType == .pad ? 200 : 200)
                    .frame(maxWidth: 200)
                    .frame(height: 25)
                    .background(Color.mangaHubColor)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 0.5))
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
