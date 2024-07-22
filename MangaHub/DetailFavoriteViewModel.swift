//
//  DetailFavoriteViewModel.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/07/24.
//

import Foundation


final class DetailFavoriteViewModel: ObservableObject {
    
    var manga: Manga
    
    var savedFavouriteMangas : [Manga] = []
    
    @Published var reading: Int = 0
    
    @Published var volumes: [Int] = []
    
    @Published var errorMessage: String = ""
    
    @Published var showAlert: Bool = false
    
    private let interactor: PersistenceProtocol
    
    init(interactor: PersistenceProtocol = PersistenceInteractor(), manga: Manga) {
        self.interactor = interactor
        self.manga = manga
        showReadingValue()
        showBoughtVolumes()
    }
    
    deinit {
        print("Cerrado")
    }
    
    func loadData() throws {
        savedFavouriteMangas = try interactor.cargar()
    }
    
    func showReadingValue() {
        reading = manga.readingVolume
    }
    
    func showBoughtVolumes() {
        volumes = manga.boughtVolumes
    }
    
    func persistReadingVolume() {
        do {
            try loadData()
            manga.readingVolume = reading
            if let index = savedFavouriteMangas.firstIndex(where: {$0.id == manga.id}) {
                savedFavouriteMangas[index] = manga
            }
            try interactor.guardar(array: savedFavouriteMangas)
        } catch {
            errorMessage = "Error persisting your reading volume"
            showAlert = true
        }
    }
    
    
    func persistBoughtVolumes(volume: Int) {
        do {
            try loadData()
            if volumes.contains(volume) {
                volumes.removeAll { $0 == volume }
            } else {
                volumes.append(volume)
            }
            manga.boughtVolumes = volumes
            if let index = savedFavouriteMangas.firstIndex(where: {$0.id == manga.id}) {
                savedFavouriteMangas[index] = manga
            }
            try interactor.guardar(array: savedFavouriteMangas)
        } catch {
            errorMessage = "Error persisting your volumes"
            showAlert = true
        }
    }

}


