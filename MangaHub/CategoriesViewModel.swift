//
//  CategoriesViewModel.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/07/24.
//

import Foundation


final class CategoriesViewModel: ObservableObject {
    
    @Published var categories: [String] = []
    @Published var mangasByCategory: [Manga] = []
    @Published var cType: categoryType?
    @Published var showAlert: Bool = false
    
    @Published var myError : ErrorsCategoriesList?
    @Published var myErrorSpecific : ErrorsMangasByCategory?
    
    private let interactor: NetworkProtocol
    
    var pageCategories = 1
    var mangasPerPage = 10
    
    init(interactor: NetworkProtocol = NetworkInteractor()) {
        self.interactor = interactor
    }
    
    func categoryTypeSelected(category: String) {
        switch cType {
        case .genres:
            fetchMangasByGenre(genre: category)
        case .demographics:
            fetchMangasByDemographic(demographic: category)
        case .themes:
            fetchMangasByTheme(theme: category)
        case .none:
            return
        }
        
    }
        
        func categorySelected(category: String) {
            categoryTypeSelected(category: category)
        }
        
        func isLastItemCategories(manga: Manga, category: String) {
            if mangasByCategory.last?.id == manga.id {
                pageCategories += 1
                categorySelected(category: category)
            }
        }
        
        
        func fetchGenres() {
            mangasByCategory.removeAll()
            Task {
                do {
                    let genres = try await interactor.getGenres()
                    await MainActor.run {
                        self.categories = genres
                    }
                } catch {
                    await MainActor.run {
                        showAlert = true
                        myError = .fetchGenres
                    }
                }
            }
        }
        
        
        func fetchMangasByGenre(genre: String) {
            Task {
                do {
                    let mangas = try await interactor.getMangaByGenre(genre: genre, page: pageCategories)
                    await MainActor.run {
                        self.mangasByCategory += mangas
                    }
                } catch {
                    await MainActor.run {
                        showAlert = true
                        myErrorSpecific = .fetchMangasByGenre
                    }
                }
            }
        }
        
        func fetchDemographics() {
            mangasByCategory.removeAll()
            Task {
                do {
                    let demographics = try await interactor.getDemographics()
                    await MainActor.run {
                        self.categories = demographics
                    }
                } catch {
                    await MainActor.run {
                        showAlert = true
                        myError = .fetchDemographics
                    }
                }
            }
        }
        
        func fetchMangasByDemographic(demographic: String) {
            Task {
                do {
                    let mangas = try await interactor.getMangaByDemographic(demographic: demographic, page: pageCategories)
                    await MainActor.run {
                        self.mangasByCategory += mangas
                    }
                } catch {
                    await MainActor.run {
                        showAlert = true
                        myErrorSpecific = .fetchMangasByDemographic
                    }
                }
            }
        }
        
        func fetchThemes() {
            mangasByCategory.removeAll()
            Task {
                do {
                    let themes = try await interactor.getThemes()
                    await MainActor.run {
                        self.categories = themes
                    }
                } catch {
                    await MainActor.run {
                        showAlert = true
                        myError = .fetchThemes
                    }
                }
            }
        }
        
        func fetchMangasByTheme(theme: String) {
            Task {
                do {
                    let mangas = try await interactor.getMangaByTheme(theme: theme, page: pageCategories)
                    await MainActor.run {
                        self.mangasByCategory += mangas
                    }
                } catch {
                    await MainActor.run {
                        showAlert = true
                        myErrorSpecific = .fetchMangasByTheme
                    }
                }
            }
        }
       
    }
    
    enum ErrorsCategoriesList : LocalizedError {
        case fetchGenres
        case fetchThemes
        case fetchDemographics
        
        var errorDescription: String {
            switch self {
            case .fetchGenres:
                "Error loading genres"
            case .fetchThemes:
                "Error loading themes"
            case .fetchDemographics:
                "Error loading demographics"
                
            }
        }
    }
    
    enum ErrorsMangasByCategory: LocalizedError {
        case fetchMangasByGenre
        case fetchMangasByDemographic
        case fetchMangasByTheme
        
        var errorDescription: String {
            switch self {
            case .fetchMangasByDemographic:
                "Error loading mangas by demographic"
            case .fetchMangasByGenre:
                "Error loading mangas by genre"
            case .fetchMangasByTheme:
                "Error loading mangas by theme"
            }
        }
    }
    
    enum categoryType {
        case genres
        case demographics
        case themes
    }

