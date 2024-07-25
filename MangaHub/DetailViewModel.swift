//
//  DetailViewModel.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/07/24.
//

import Foundation


final class DetailViewModel: ObservableObject {
    
    var manga: Manga
    var savedFavouriteMangas: [Manga] = []
    
    @Published var isDisable = false
    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var lastFunctionCalled: MangaDetailFunctions?
    
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
        lastFunctionCalled = .saveFavourite
        do{
            try loadData()
            if !savedFavouriteMangas.contains(where: { $0.id == manga.id }) {
                savedFavouriteMangas.append(manga)
            }
            try interactor.saveMangas(array: savedFavouriteMangas)
        } catch {
            showAlert = true
            errorMessage = "Error saving manga as favourite"
        }
    }
    
    // Función que verifica al iniciar la vista si un manga ha sido perisistido como favorito o no.
    func checkFavourite() {
        lastFunctionCalled = .checkFavourite
        do {
            try loadData()
            if savedFavouriteMangas.contains(where: { $0.id == manga.id }) {
                isDisable = true
            }
        } catch {
            showAlert = true
            errorMessage = "Error loading manga data"
        }
    }
}

// Representa las funciones llamadas en la vista 'MangaDetailView'
enum MangaDetailFunctions {
    case saveFavourite
    case checkFavourite
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
