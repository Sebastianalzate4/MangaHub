//
//  ListFavoritesViewModel.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/07/24.
//

import Foundation

final class ListFavoritesViewModel : ObservableObject {
    
    @Published var loadedFavouriteMangas : [Manga] = []
    
    @Published var containsFavourites = false
    
    @Published var searchFavManga = ""
    
    @Published var errorMessage: String = ""
    
    @Published var showAlert: Bool = false
    
    private let interactor : PersistenceProtocol
    
    init(interactor: PersistenceProtocol = PersistenceInteractor()) {
        self.interactor = interactor
    }
    
    deinit {
        print("Lista Favoritos Cerrada")
    }
    
    func showFavourites() {
        do {
            loadedFavouriteMangas = try interactor.cargar()
        } catch {
            errorMessage = "Failed to show the list of mangas. Try closing the app and reopen it again."
            showAlert = true
        }
    }
    
    func deleteManga(indexSet: IndexSet) {
        loadedFavouriteMangas.remove(atOffsets: indexSet)
        do {
            try interactor.guardar(array: loadedFavouriteMangas)
        } catch {
            errorMessage = "Failed to save changes. Try closing the app and reopen it again."
            showAlert = true
        }
    }

    
    var filteredMangas: [Manga] {
        loadedFavouriteMangas
            .filter {
                guard !searchFavManga.isEmpty else { return true }
                let searchText = searchFavManga.lowercased()
                return $0.title.lowercased().contains(searchText)
            }
    }
    
}


