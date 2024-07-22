//
//  FavoriteMangasListView.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/07/24.
//

import SwiftUI

struct FavoriteMangasListView: View {
    
    @StateObject var viewmodel = ListFavoritesViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewmodel.loadedFavouriteMangas.isEmpty {
                    
                    MangaUnavailableView(systemName: "heart.fill", title: "Add your favorite mangas here", subtitle: "Track your progress")
                        
                } else {

                    List {
                        ForEach(viewmodel.filteredMangas) { manga in
                            NavigationLink(value: manga) {
                                MangaCellView(manga: manga)
                            }
                        }
                        .onDelete(perform: viewmodel.deleteManga)
                    }
                    .toolbar {
                        ToolbarItem(placement: .automatic) {
                            EditButton()
                        }
                    }
                }
            }
            
            .alert("Something Went Wrong.", isPresented: $viewmodel.showAlert) {
                Button(role: .cancel) {
                    viewmodel.showAlert = false
                } label: {
                    Text("Ok")
                }
            } message: {
                Text(viewmodel.errorMessage)
            }
            .searchable(text: $viewmodel.searchFavManga, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("Search Favourite Manga"))
            .onAppear {
                viewmodel.showFavourites()
            }
            .navigationDestination(for: Manga.self) { manga in
                FavoriteMangaDetailView(viewmodel: DetailFavoriteViewModel(manga: manga))
            }
            .navigationTitle("My Favorite Mangas")
        }
    }
}



#Preview {
    FavoriteMangasListView()
}


