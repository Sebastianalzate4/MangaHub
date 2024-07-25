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
    
    @Published var readingValue: Int = 0
    @Published var volumes: [Int] = []
    @Published var errorMessage: String = ""
    @Published var showAlert: Bool = false
    
    private let interactor: PersistenceProtocol
    
    init(interactor: PersistenceProtocol = PersistenceInteractor(), manga: Manga) {
        self.interactor = interactor
        self.manga = manga
        updateReadingValue()
        updateBoughtVolumes()
    }

    // Función que carga los mangas que se encuentren persistidos en el sandbox / JSON.
    func loadData() throws {
        savedFavouriteMangas = try interactor.loadMangas()
    }
    
    // Función que actualiza el número de volúmenes leídos por el usuario en la vista cada vez que se inicializa.
    func updateReadingValue() {
        readingValue = manga.readingVolume
    }
    
    // Función que actualiza los volúmenes comprados por el usuario en la vista cada vez que se inicializa.
    func updateBoughtVolumes() {
        volumes = manga.purchasedVolumes
    }
    
    // Función que persiste el volúmen por el cuál va leyendo el usuario. Primero carga los mangas persistidos, luego sobreescribe el valor de la propiedad que lleva la trazabilidad de los volúmenes leídos en el manga, luego encontramos su posición por el id en el array para poder reemplazarlo ya que al alterarse una de sus propiedades, ya es considerado un elemento nuevo. Y finalmente, persistimos los cambios.
    func persistReadingVolume() {
        do {
            try loadData()
            manga.readingVolume = readingValue
            if let index = savedFavouriteMangas.firstIndex(where: {$0.id == manga.id}) {
                savedFavouriteMangas[index] = manga
            }
            try interactor.saveMangas(array: savedFavouriteMangas)
        } catch {
            errorMessage = "Error persisting your reading volume"
            showAlert = true
        }
    }
    
    // Función que persiste el volúmen comprado por el usuario. Primero carga los mangas persistidos, la idea es verificar si se encuentra o no agregado ya en la colección por si el usuario quiere quitarlo o no, luego en caso de no tenerlo, se agrega como nuevo elemento. Posteriormente, se sobreescribe el array en el manga y encontramos su posición en el array para sustituirlo ya que ahora es un nuevo elemento.Y finalmente, persistimos los cambios.
    func persistPurchasedVolumes(volume: Int) {
        do {
            try loadData()
            if volumes.contains(volume) {
                volumes.removeAll { $0 == volume }
            } else {
                volumes.append(volume)
            }
            manga.purchasedVolumes = volumes
            if let index = savedFavouriteMangas.firstIndex(where: {$0.id == manga.id}) {
                savedFavouriteMangas[index] = manga
            }
            try interactor.saveMangas(array: savedFavouriteMangas)
        } catch {
            errorMessage = "Error persisting your purchased volume"
            showAlert = true
        }
    }
}


