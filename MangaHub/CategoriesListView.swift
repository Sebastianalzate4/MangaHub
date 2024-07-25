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
            // Botones para seleccionar una categoría.
            VStack {
                ScrollView(.horizontal) {
                    HStack {
                        Button {
                            viewmodel.Genres()
                            viewmodel.categoryType = .genres
                        } label: {
                            Text("Genres")
                        }
                        .mangaHubButtonSelected(isSelected: viewmodel.categoryType == .genres)
                        
                        Button {
                            viewmodel.Demographics()
                            viewmodel.categoryType = .demographics
                        } label: {
                            Text("Demographics")
                        }
                        .mangaHubButtonSelected(isSelected: viewmodel.categoryType == .demographics)
                        
                        Button {
                            viewmodel.Themes()
                            viewmodel.categoryType = .themes
                        } label: {
                            Text("Themes")
                        }
                        .mangaHubButtonSelected(isSelected: viewmodel.categoryType == .themes)
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                Group {
                    // Mientras no haya ninguna categoría seleccionada y el array de subcategorías esté vacío, mostraremos la 'MangaUnavailableView'
                    if viewmodel.subcategories.isEmpty {
                        VStack {
                            MangaUnavailableView(systemName: "arrowshape.up.circle.fill", title: "Select a Category", subtitle: "Display a list of mangas by a specific subcategory")
                        }
                        .padding()
                    } else {
                        // Listado de subcategorías de acuerdo a la categoría seleccionada.
                        List(viewmodel.subcategories.sorted(), id: \.self) { subcategory in
                            NavigationLink(value: subcategory) {
                                Text(subcategory)
                            }
                            .listRowBackground(Color.clear)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                
                Spacer()
            }
            .navigationTitle("Categories")
            .navigationDestination(for: String.self) { subcategory in
                MangasByCategoryView(pathCategories: $pathCategories, subcategory: subcategory, category: viewmodel.categoryType ?? .genres)
            }
            .navigationDestination(for: Manga.self) { manga in
                MangaDetailView(viewmodel: DetailViewModel(manga: manga))
            }
            .navigationDestination(for: Author.self) { author in
                MangasByAuthorView(path: $pathCategories, author: author)
            }
            .alert("Something went wrong", isPresented: $viewmodel.showAlert) {
                Button("Try Again") {
                    switch viewmodel.categoryType {
                    case .genres: viewmodel.Genres()
                    case .themes: viewmodel.Themes()
                    case .demographics: viewmodel.Demographics()
                    default:
                        break
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text(viewmodel.errorMessage)
            }
        }
    }
}

#Preview {
    NavigationStack {
        CategoriesListView()
    }
}
