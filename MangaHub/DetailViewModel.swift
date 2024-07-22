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
    
    @Published var myError : ErrorsMangaDetail?
    
    @Published var information : InformationButtons = .description
    
    private let interactor : PersistenceProtocol
    
    init(interactor: PersistenceProtocol = PersistenceInteractor(), manga: Manga) {
        self.interactor = interactor
        self.manga = manga
        try? loadData()
    }
    
    deinit {
        print("Correctamente cerrado")
    }
    
    func loadData() throws {
        savedFavouriteMangas = try interactor.cargar()
    }
    
    func saveFavourite() {
        do{
            try loadData()
            if !savedFavouriteMangas.contains(where: { $0.id == manga.id }) {
                savedFavouriteMangas.append(manga)
            }
            try interactor.guardar(array: savedFavouriteMangas)
        } catch {
            showAlert = true
            myError = .saveFavourite
        }
    }
    
    func checkFavourite() {
        do {
            try loadData()
            if savedFavouriteMangas.contains(where: { $0.id == manga.id }) {
                isDisable = true
            }
        } catch {
            showAlert = true
            myError = .checkFavourite
        }
    }
}


enum ErrorsMangaDetail : LocalizedError {
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

enum InformationButtons: CaseIterable, Identifiable {
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
