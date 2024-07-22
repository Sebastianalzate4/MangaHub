//
//  MangaScoreView.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/07/24.
//

import SwiftUI

struct MangaScoreView: View {
    
    var manga: Manga
    @State var progress: Bool = false
    
    var body: some View {
        Text(manga.formattedScore)
            .bold()
            .font(.footnote)
            .foregroundColor(.black)
            .padding(6)
            .background {
                Circle()
                    .fill(Color.white)
            }
            .background {
                Circle()
                    .trim(from: 0.0, to: progress ? (manga.score / 10) : 0)
                    .stroke(lineWidth: 6)
                    .fill(manga.score > 8 ? Color.orange : Color.red)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1), value: progress)
            }
            .background {
                Circle()
                    .stroke(lineWidth: 6)
                    .fill(Color.gray)
            }
            .onAppear {
                progress = true
            }
//            .offset(x: 1, y: 1)
    }
}

#Preview {
    MangaScoreView(manga: .preview)
}

