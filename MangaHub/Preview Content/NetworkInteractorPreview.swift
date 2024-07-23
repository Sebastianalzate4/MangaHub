//
//  NetworkInteractorPreview.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/07/24.
//

import Foundation

struct NetworkInteractorPreview: NetworkProtocol {
    
    // Carga de los datos desde el JSON en el bundle para la Preview de 'MangaListView'.
    func fetchAllMangasPaginated(page: Int, mangasPerPage: Int) throws -> [Manga] {
        guard let url = Bundle.main.url(forResource: "MangasPreview", withExtension: "json") else { throw LocalErrors.loadError }
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.customDateFormatter)
        return try decoder.decode(MangaGeneralDTO.self, from: data).items.map(\.mapToManga)
    }
    
    // No son usadas para mostrar datos en la Preview.
    func fetchAllMangas() async throws -> [Manga]{ return [] }
    func fetchBestMangas(page: Int, mangasPerPage: Int) async throws -> [Manga]{ return [] }
    
    func fetchMangasByGenre(genre: String, page: Int) async throws -> [Manga]{ return [] }
    func fetchMangasByTheme(theme: String, page: Int) async throws -> [Manga]{ return [] }
    func fetchMangasByDemographic(demographic: String, page: Int) async throws -> [Manga]{ return [] }
    func fetchMangasByAuthor(idAuthor: String, page: Int, mangasPerPage: Int) async throws -> [Manga]{ return [] }
    
    func fetchGenres() async throws -> [String]{ return [] }
    func fetchDemographics() async throws -> [String]{ return [] }
    func fetchThemes() async throws -> [String]{ return [] }
    func fetchAuthors() async throws -> [Author]{ return [] }
    
    func fetchSearchedMangas(text: String, page: Int) async throws -> [Manga]{ return [] }
}

// Error para la carga de los datos en local para la preview.
enum LocalErrors: Error {
    case loadError
}

extension NetworkProtocol where Self == NetworkInteractorPreview {
    static var preview: Self { NetworkInteractorPreview() }
}





