//
//  PersistenceInteractor.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/07/24.
//

import Foundation

let urlDocumentFolder = URL.documentsDirectory.appending(path: "MyMangas.json")

protocol PersistenceProtocol {
    func guardar(array: [Manga]) throws
    func cargar() throws -> [Manga]
}


struct PersistenceInteractor : PersistenceProtocol {
    
    func guardar(array: [Manga]) throws {
        let encondedData = try JSONEncoder().encode(array)
        try encondedData.write(to: urlDocumentFolder, options: .atomic)
    }
    
    func cargar() throws -> [Manga] {
        if FileManager.default.fileExists(atPath: urlDocumentFolder.path()) {
            let data = try Data(contentsOf: urlDocumentFolder)
            let decodedMangas = try JSONDecoder().decode([Manga].self, from: data)
            return decodedMangas
        } else {
            return []
        }
    }
}
