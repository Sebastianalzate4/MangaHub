//
//  PreviewInteractor.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/07/24.
//

import Foundation


struct PreviewInteractor: NetworkProtocol {
    func getAllMangas() async throws -> [Manga]{ return [] }
    
    func getAllMangasPaginated(page: Int, mangasPerPage: Int) throws -> [Manga] {
        guard let url = Bundle.main.url(forResource: "MangasPreview", withExtension: "json") else { throw LocalErrors.loadError }
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.customDateFormatter)
        return try decoder.decode(MangaGeneralDTO.self, from: data).items.map(\.mapToModel)
    }
    
    func getBestMangas(page: Int, mangasPerPage: Int) async throws -> [Manga]{ return [] }
    
    
    func getMangaByGenre(genre: String, page: Int) async throws -> [Manga]{ return [] }
    func getMangaByTheme(theme: String, page: Int) async throws -> [Manga]{ return [] }
    func getMangaByDemographic(demographic: String, page: Int) async throws -> [Manga]{ return [] }
    func getMangaByAuthorPaginated(idAuthor: String, page: Int, mangasPerPage: Int) async throws -> [Manga]{ return [] }
    
    
    func getGenres() async throws -> [String]{ return [] }
    func getDemographics() async throws -> [String]{ return [] }
    func getThemes() async throws -> [String]{ return [] }
    func getAuthors() async throws -> [Author]{ return [] }
    
    
    func searchMangaContains(text: String, page: Int) async throws -> [Manga]{ return [] }
    
}


enum LocalErrors: Error {
    case loadError
}


extension NetworkProtocol where Self == PreviewInteractor {
    static var preview: Self { PreviewInteractor() }
}





