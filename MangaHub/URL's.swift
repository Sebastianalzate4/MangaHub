//
//  URL's.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/07/24.
//

import Foundation

// URL bases:
let listBaseURL: URL = URL(string: "https://mymanga-acacademy-5607149ebe3d.herokuapp.com/list")!
let searchBaseURL: URL = URL(string: "https://mymanga-acacademy-5607149ebe3d.herokuapp.com/search")!

// Endpoints:
extension URL {
    
    static let allMangasURL: URL = listBaseURL.appending(path: "mangas")
    static let bestMangasURL: URL = listBaseURL.appending(path: "bestMangas")
    static let genresURL: URL = listBaseURL.appending(path: "genres")
    static let authorsURL: URL = listBaseURL.appending(path: "authors")
    static let demographicsURL: URL = listBaseURL.appending(path: "demographics")
    static let themesURL: URL = listBaseURL.appending(path: "themes")
    
    static func getSearchContainsURL(text: String, page: Int) -> URL {
        let url = searchBaseURL.appending(path: "mangasContains").appending(path: text)
            .appending(queryItems: [.getPage(pageNumber: page)])
        print(url)
        return url
    }
    
    static func getAllMangasPaginatedURL(page: Int, mangasPerPage: Int = 10) -> URL {
        let url = allMangasURL
            .appending(queryItems: [.getPage(pageNumber: page)])
        print(url)
        return url
    }
    
    static func getBestMangasURL(page: Int, mangasPerPage: Int = 10) -> URL {
        let url = bestMangasURL
            .appending(queryItems: [.getPage(pageNumber: page)])
        print(url)
        return url
    }
    
    
    static func getMangaByAuthorURL(authorID: String, page: Int, mangasPerPage: Int = 10) -> URL {
        let url = listBaseURL.appending(path: "mangaByAuthor/\(authorID)")
            .appending(queryItems: [.getPage(pageNumber: page)])
        print(url)
        return url
    }
    
    
    static func getMangaByGenreURL(genre: String, page: Int) -> URL {
        let url = listBaseURL.appending(path: "mangaByGenre/\(genre)")
            .appending(queryItems: [.getPage(pageNumber: page)])
        print(url)
        return url
    }
    
    
    static func getMangaByDemographicsURL(demographic: String, page: Int) -> URL {
        let url = listBaseURL.appending(path: "mangaByDemographic/\(demographic)")
            .appending(queryItems: [.getPage(pageNumber: page)])
        print(url)
        return url
    }
    
    
    static func getMangaByThemeURL(theme: String, page: Int) -> URL {
        let url = listBaseURL.appending(path: "mangaByTheme/\(theme)")
            .appending(queryItems: [.getPage(pageNumber: page)])
        print(url)
        return url
    }
    
}



