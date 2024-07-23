//
//  ListFavoritesViewModel.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/07/24.
//

import Foundation

final class ListFavoritesViewModel : ObservableObject {
    
    @Published var loadedFavoriteMangas : [Manga] = []
    @Published var containsFavourites = false
    @Published var searchedManga = ""
    @Published var errorMessage: String = ""
    @Published var showAlert: Bool = false
    
    private let interactor : PersistenceProtocol
    
    init(interactor: PersistenceProtocol = PersistenceInteractor()) {
        self.interactor = interactor
    }
    
    // Función que carga los favoritos desde el sandbox y luego los asigna al array 'loaderFavoriteMangas'
    func showFavourites() {
        do {
            loadedFavoriteMangas = try interactor.loadMangas()
        } catch {
            errorMessage = "Failed to show the list of mangas. Try closing the app and reopen it again."
            showAlert = true
        }
    }
    
    // Función que elimina los mangas de la lista de favoritos y persiste el cambio.
    func deleteManga(indexSet: IndexSet) {
        loadedFavoriteMangas.remove(atOffsets: indexSet)
        do {
            try interactor.saveMangas(array: loadedFavoriteMangas)
        } catch {
            errorMessage = "Failed to save changes. Try closing the app and reopen it again."
            showAlert = true
        }
    }
    
    // Búsqueda de mangas en local.
    var filteredMangas: [Manga] {
        loadedFavoriteMangas
            .filter {
                guard !searchedManga.isEmpty else { return true }
                let searchedText = searchedManga.lowercased()
                return $0.title.lowercased().contains(searchedText)
            }
    }
}


