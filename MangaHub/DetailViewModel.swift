//
//  DetailViewModel.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/07/24.
//

import Foundation


final class DetailViewModel: ObservableObject {
    
    var manga: Manga
    var savedFavoriteMangas: [Manga] = []
    
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
        savedFavoriteMangas = try interactor.loadMangas()
    }
    
    // Función que persiste 1 manga como Favorito
    func saveFavorite() {
        lastFunctionCalled = .saveFavorite
        do{
            try loadData()
            if !savedFavoriteMangas.contains(where: { $0.id == manga.id }) {
                savedFavoriteMangas.append(manga)
            }
            try interactor.saveMangas(array: savedFavoriteMangas)
        } catch {
            showAlert = true
            errorMessage = "Error saving manga as favorite"
        }
    }
    
    // Función que verifica al iniciar la vista si un manga ha sido perisistido como favorito o no.
    func checkFavorite() {
        lastFunctionCalled = .checkFavorite
        do {
            try loadData()
            if savedFavoriteMangas.contains(where: { $0.id == manga.id }) {
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
    case saveFavorite
    case checkFavorite
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
