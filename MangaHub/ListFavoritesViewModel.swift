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
    @Published var lastFunctionCalled: FavoriteMangasListFunctions?
    @Published var errorIndexSet: IndexSet?
    
    private let interactor : PersistenceProtocol
    
    init(interactor: PersistenceProtocol = PersistenceInteractor()) {
        self.interactor = interactor
    }
    
    // Función que carga los favoritos desde el sandbox y luego los asigna al array 'loadedFavoriteMangas'
    func showFavorites() {
        lastFunctionCalled = .showFavorites
        do {
            loadedFavoriteMangas = try interactor.loadMangas()
        } catch {
            errorMessage = "Failed to show the list of mangas. Try closing the app and reopen it again."
            showAlert = true
        }
    }
    
    // Función que elimina los mangas de la lista de favoritos y persiste el cambio.
    func deleteManga(indexSet: IndexSet) {
        lastFunctionCalled = .deleteManga
        loadedFavoriteMangas.remove(atOffsets: indexSet)
        do {
            try interactor.saveMangas(array: loadedFavoriteMangas)
        } catch {
            errorIndexSet = indexSet
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

// Representa las funciones usadas en 'FavoriteMangasList' para poder hacer una trazabilidad de cuál fue la última función en ser llamada.

enum FavoriteMangasListFunctions {
    case showFavorites
    case deleteManga
}
