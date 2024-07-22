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
                        Button {
                            viewmodel.fetchGenres()
                            viewmodel.cType = .genres
                        } label: {
                            Text("Genres")
                        }
                        .mangaHubButtonCategories(isSelected: viewmodel.cType == .genres)
                        
                        Button {
                            viewmodel.fetchDemographics()
                            viewmodel.cType = .demographics
                        } label: {
                            Text("Demographics")
                        }
                        .mangaHubButtonCategories(isSelected: viewmodel.cType == .demographics)
                        
                        Button {
                            viewmodel.fetchThemes()
                            viewmodel.cType = .themes
                        } label: {
                            Text("Themes")
                        }
                        .mangaHubButtonCategories(isSelected: viewmodel.cType == .themes)
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                Group {
                    if viewmodel.categories.isEmpty {
                        VStack {
                            MangaUnavailableView(systemName: "arrowshape.up.circle.fill", title: "Select a Category", subtitle: "Display a list of mangas by a specific category")
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
                Button {
                    switch error {
                    case .fetchGenres : viewmodel.fetchGenres()
                    case .fetchThemes : viewmodel.fetchThemes()
                    case .fetchDemographics : viewmodel.fetchDemographics()
                    }
                } label: {
                    Text("Try Again")
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
