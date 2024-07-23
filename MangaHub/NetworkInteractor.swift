//
//  NetworkInteractor.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/07/24.
//

import Foundation

protocol NetworkProtocol {
    
    func fetchAllMangas() async throws -> [Manga]
    func fetchAllMangasPaginated(page: Int, mangasPerPage: Int) async throws -> [Manga]
    func fetchBestMangas(page: Int, mangasPerPage: Int) async throws -> [Manga]
    
    func fetchMangasByGenre(genre: String, page: Int) async throws -> [Manga]
    func fetchMangasByTheme(theme: String, page: Int) async throws -> [Manga]
    func fetchMangasByDemographic(demographic: String, page: Int) async throws -> [Manga]
    func fetchMangasByAuthor(idAuthor: String, page: Int, mangasPerPage: Int) async throws -> [Manga]
    
    func fetchGenres() async throws -> [String]
    func fetchDemographics() async throws -> [String]
    func fetchThemes() async throws -> [String]
    func fetchAuthors() async throws -> [Author]
    
    func fetchSearchedMangas(text: String, page: Int) async throws -> [Manga]
}


struct NetworkInteractor: NetworkProtocol {
    
    // Cada una de estas funciones hace uso de la función genérica para el llamado a red con su respectivo endpoint.
    
    func fetchAllMangas() async throws -> [Manga] {
        return try await fetchDataGeneric(url: .allMangasURL, type: MangaGeneralDTO.self).items.map(\.mapToManga)
    }
    
    func fetchBestMangas(page: Int = 1, mangasPerPage: Int = 10) async throws -> [Manga] {
        return try await fetchDataGeneric(url: .getBestMangasURL(page: page), type: MangaGeneralDTO.self).items.map(\.mapToManga)
    }
    
    func fetchAllMangasPaginated(page: Int = 1, mangasPerPage: Int = 10) async throws -> [Manga] {
        return try await fetchDataGeneric(url: .getAllMangasPaginatedURL(page: page, mangasPerPage: mangasPerPage), type: MangaGeneralDTO.self).items.map(\.mapToManga)
    }
    
    
    func fetchMangasByGenre(genre: String, page: Int) async throws -> [Manga] {
        return try await fetchDataGeneric(url: .getMangaByGenreURL(genre: genre, page: page), type: MangaGeneralDTO.self).items.map(\.mapToManga)
    }
    
    func fetchMangasByTheme(theme: String, page: Int) async throws -> [Manga] {
        return try await fetchDataGeneric(url: .getMangaByThemeURL(theme: theme, page: page), type: MangaGeneralDTO.self).items.map(\.mapToManga)
    }
    
    func fetchMangasByDemographic(demographic: String, page: Int) async throws -> [Manga] {
        return try await fetchDataGeneric(url: .getMangaByDemographicsURL(demographic: demographic, page: page), type: MangaGeneralDTO.self).items.map(\.mapToManga)
    }
    
    func fetchMangasByAuthor(idAuthor: String, page: Int = 1, mangasPerPage: Int = 10) async throws -> [Manga] {
        return try await fetchDataGeneric(url: .getMangaByAuthorURL(authorID: idAuthor, page: page, mangasPerPage: mangasPerPage), type: MangaGeneralDTO.self).items.map(\.mapToManga)
    }
    
    
    func fetchGenres() async throws -> [String] {
        return try await fetchDataGeneric(url: .genresURL, type: [String].self)
    }
    
    func fetchDemographics() async throws -> [String] {
        return try await fetchDataGeneric(url: .demographicsURL, type: [String].self)
    }
    
    func fetchThemes() async throws -> [String] {
        return try await fetchDataGeneric(url: .themesURL, type: [String].self)
    }
    
    func fetchAuthors() async throws -> [Author] {
        return try await fetchDataGeneric(url: .authorsURL, type: [Author].self)
    }
    
    
    func fetchSearchedMangas(text: String, page: Int) async throws -> [Manga] {
        return try await fetchDataGeneric(url: .getSearchContainsURL(text: text, page: page), type: MangaGeneralDTO.self).items.map(\.mapToManga)
    }
}
