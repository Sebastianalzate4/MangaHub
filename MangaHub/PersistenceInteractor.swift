//
//  PersistenceInteractor.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/07/24.
//

import Foundation

let urlDocumentFolder = URL.documentsDirectory.appending(path: "MyMangas.json")

protocol PersistenceProtocol {
    func saveMangas(array: [Manga]) throws
    func loadMangas() throws -> [Manga]
}


struct PersistenceInteractor : PersistenceProtocol {
    
    // Función para guardar en local los mangas marcados como favoritos.
    func saveMangas(array: [Manga]) throws {
        let encondedData = try JSONEncoder().encode(array)
        try encondedData.write(to: urlDocumentFolder, options: .atomic)
    }
    
    // Función para cargar los mangas desde el sandbox de la app.
    func loadMangas() throws -> [Manga] {
        if FileManager.default.fileExists(atPath: urlDocumentFolder.path()) {
            let data = try Data(contentsOf: urlDocumentFolder)
            let decodedMangas = try JSONDecoder().decode([Manga].self, from: data)
            return decodedMangas
        } else {
            return []
        }
    }
}
