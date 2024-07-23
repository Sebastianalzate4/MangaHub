//
//  DetailsSectionView.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 20/07/24.
//

import SwiftUI

struct DetailsSectionView: View {
    
    var manga: Manga
    
    // Form para presentar todos los datos del manga. 
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Titles 🖋️")) {
                    HStack {
                        Text("Japanese")
                            .foregroundStyle(Color.secondary)
                        Spacer()
                        Text(manga.titleJapanese ?? "No Japanese Title")
                            .padding(.vertical, 8)
                    }
                    HStack {
                        Text("English")
                            .foregroundStyle(Color.secondary)
                        Spacer()
                        Text(manga.titleEnglish ?? "No English Title")
                            .padding(.vertical, 8)
                    }
                }
                
                Section(header: Text("Authors 🧑🏻‍💻")) {
                    HStack {
                        Text("Authors")
                            .foregroundStyle(Color.secondary)
                        Spacer()
                        VStack(alignment: .leading){
                            ForEach(manga.authors) { author in
                                Text("- \(author.authorCompleteName)")
                                    .foregroundStyle(Color.primary)
                            }
                        }
                    }
                }
                
                
                Section(header: Text("Content 📖")) {
                    HStack {
                        Text("Chapters")
                            .foregroundStyle(Color.secondary)
                        Spacer()
                        Text("\(manga.formattedChapters)")
                            .padding(.vertical, 8)
                    }
                    HStack {
                        Text("Volumes")
                            .foregroundStyle(Color.secondary)
                        Spacer()
                        Text("\(manga.formattedVolumes)")
                            .padding(.vertical, 8)
                    }
                }
                
                Section(header: Text("Score 🥇")) {
                    HStack {
                        Text("Rate")
                            .foregroundStyle(Color.secondary)
                        Spacer()
                        Text(manga.formattedScore)
                            .padding(.vertical, 8)
                    }
                }
                
                Section(header: Text("Dates 📆")) {
                    HStack {
                        Text("Start Date")
                            .foregroundStyle(Color.secondary)
                        Spacer()
                        Text(manga.formattedStartDate)
                            .padding(.vertical, 8)
                    }
                    HStack {
                        Text("End Date")
                            .foregroundStyle(Color.secondary)
                        Spacer()
                        Text(manga.formattedEndDate)
                            .padding(.vertical, 8)
                    }
                    HStack {
                        Text("Status")
                            .foregroundStyle(Color.secondary)
                        Spacer()
                        Text(manga.formattedStatus)
                            .padding(.vertical, 8)
                    }
                }
                
                Section(header: Text("Categories 📚")) {
                    HStack {
                        Text("Genres")
                            .foregroundStyle(Color.secondary)
                        Spacer()
                        VStack(alignment: .leading){
                            ForEach(manga.genres) { genre in
                                Text("- \(genre.genre)")
                                    .foregroundStyle(Color.primary)
                            }
                        }
                    }
                    
                    
                    HStack {
                        Text("Demographics")
                            .foregroundStyle(Color.secondary)
                        Spacer()
                        VStack(alignment: .leading){
                            ForEach(manga.demographics) { demographic in
                                Text("- \(demographic.demographic)")
                                    .foregroundStyle(Color.primary)
                            }
                        }
                    }
                    
                    
                    HStack {
                        Text("Themes")
                            .foregroundStyle(Color.secondary)
                        Spacer()
                        VStack(alignment: .leading){
                            ForEach(manga.themes) { theme in
                                Text("- \(theme.theme)")
                                    .foregroundStyle(Color.primary)
                            }
                        }
                    }
                }
                
                
                Section(header: Text("Link to website 🌐")) {
                    Link(destination: manga.validURL) {
                        HStack(spacing: 20.0) {
                            Image(systemName: "link")
                                .font(.subheadline)
                            Text("Go to manga website")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.mangaHubColor)
                        .foregroundColor(.white)
                        .cornerRadius(10.0)
                        .padding()
                    }
                }
                
            }
        }
        .scrollIndicators(.hidden)
        .frame(height: 700)
    }
}

#Preview {
    DetailsSectionView(manga: .preview)
}
