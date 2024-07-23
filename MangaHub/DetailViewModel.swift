//
//  DetailViewModel.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/07/24.
//

import Foundation


final class DetailViewModel: ObservableObject {
    
    var manga: Manga
    var savedFavouriteMangas : [Manga] = []
    
    @Published var isDisable = false
    @Published var showAlert: Bool = false
    @Published var mangaDetailError : MangaDetailErrors?
    
    private let interactor : PersistenceProtocol
    
    init(interactor: PersistenceProtocol = PersistenceInteractor(), manga: Manga) {
        self.interactor = interactor
        self.manga = manga
        try? loadData()
    }
    
    // Función que carga los mangas que se encuentren persistidos en el sandbox / JSON.
    func loadData() throws {
        savedFavouriteMangas = try interactor.loadMangas()
    }
    
    // Función que persiste 1 manga como Favorito
    func saveFavourite() {
        do{
            try loadData()
            if !savedFavouriteMangas.contains(where: { $0.id == manga.id }) {
                savedFavouriteMangas.append(manga)
            }
            try interactor.saveMangas(array: savedFavouriteMangas)
        } catch {
            showAlert = true
            mangaDetailError = .saveFavourite
        }
    }
    
    // Función que verifica al iniciar la vista si un manga ha sido perisistido como favorito o no.
    func checkFavourite() {
        do {
            try loadData()
            if savedFavouriteMangas.contains(where: { $0.id == manga.id }) {
                isDisable = true
            }
        } catch {
            showAlert = true
            mangaDetailError = .checkFavourite
        }
    }
}

// Errores en caso de que falle alguna función.

enum MangaDetailErrors : LocalizedError {
    case saveFavourite
    case checkFavourite
    
    var errorDescription: String {
        switch self {
        case .saveFavourite:
            "Error saving manga as favourite"
        case .checkFavourite:
            "Error loading manga data"
        }
    }
}

// Enum para el filtrado de información que el usuario desee ver

enum InformationFilteringButtons: CaseIterable, Identifiable {
    case description
    case authors
    case details
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .description:
            return "Description"
        case .authors:
            return "Authors"
        case .details:
            return "Details"
        }
    }
}
