//
//  CategoriesListView.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/07/24.
//

import SwiftUI

struct CategoriesListView: View {
    
    @StateObject var viewmodel = CategoriesViewModel()
    @State private var pathCategories = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $pathCategories) {
            VStack {
                ScrollView(.horizontal) {
                    HStack {
                        Button("Genres") {
                            viewmodel.fetchGenres()
                            viewmodel.cType = .genres
                        }
                        .mangaHubButtonCategories(isSelected: viewmodel.cType == .genres)
//                        .buttonStyle(MangaHubCategoriesButtonStyle(isSelected: viewmodel.cType == .genres))
                        
                        
                        Button("Demographics") {
                            viewmodel.fetchDemographics()
                            viewmodel.cType = .demographics
                        }
                        .mangaHubButtonCategories(isSelected: viewmodel.cType == .demographics)
//                        .buttonStyle(MangaHubCategoriesButtonStyle(isSelected: viewmodel.cType == .demographics))
                        
                        Button("Themes") {
                            viewmodel.fetchThemes()
                            viewmodel.cType = .themes
                        }
                        .mangaHubButtonCategories(isSelected: viewmodel.cType == .themes)
//                        .buttonStyle(MangaHubCategoriesButtonStyle(isSelected: viewmodel.cType == .themes))
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                Group {
                    if viewmodel.categories.isEmpty {
                        VStack {
                            Image(systemName: "arrowshape.up.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .foregroundColor(.orange)
                            Text("Select a Category")
                                .bold()
                                .font(.title3)
                            Text("to make the mangas show up")
                                .foregroundColor(.secondary)
                                .font(.callout)
                                .bold()
                        }
                        .padding()
                    } else {
                        List(viewmodel.categories, id: \.self) { category in
                            NavigationLink(value: category) {
                                Text(category)
                            }
                            .listRowBackground(Color.clear)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                
                Spacer()
            }
            .navigationTitle("Categories")
            .navigationDestination(for: String.self) { category in
                MangasByCategoryView(pathCategories: $pathCategories, category: category, type: viewmodel.cType ?? .genres)
            }
            .navigationDestination(for: Manga.self) { manga in
                MangaDetailView(viewmodel: DetailViewModel(manga: manga))
            }
            .navigationDestination(for: Author.self) { author in
                MangasByAuthorView(path: $pathCategories, author: author)
            }
            .alert("Something went wrong", isPresented: $viewmodel.showAlert, presenting: viewmodel.myError) { error in
                Button("Try again") {
                    switch error {
                    case .fetchGenres : viewmodel.fetchGenres()
                    case .fetchThemes : viewmodel.fetchThemes()
                    case .fetchDemographics : viewmodel.fetchDemographics()
                    }
                }
                Button {
                    viewmodel.showAlert = false
                } label: {
                    Text("Cancel")
                }
            } message: {
                Text($0.errorDescription)
            }
        }
    }
}

#Preview {
    NavigationStack {
        CategoriesListView()
    }
}
