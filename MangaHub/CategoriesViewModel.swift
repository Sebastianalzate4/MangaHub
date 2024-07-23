//
//  CategoriesViewModel.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/07/24.
//

import Foundation


final class CategoriesViewModel: ObservableObject {
    
    @Published var subcategories: [String] = []
    @Published var mangasByCategory: [Manga] = []
    @Published var categoryType: categoryType?
    @Published var showAlert: Bool = false
    @Published var categoriesListError : CategoriesListErrors?
    @Published var mangasByCategoryError : MangasByCategoryErrors?
    
    var pageCategories = 1
    var mangasPerPage = 10
    
    private let interactor: NetworkProtocol
    
    init(interactor: NetworkProtocol = NetworkInteractor()) {
        self.interactor = interactor
    }
    
    // Función para llamar a la lista de mangas por la categoría y subcategoría correspondiente.
    func mangasByCategoryTypeSelected(subcategory: String) {
        switch categoryType {
        case .genres:
            MangasByGenre(genre: subcategory)
        case .demographics:
            MangasByDemographic(demographic: subcategory)
        case .themes:
            MangasByTheme(theme: subcategory)
        case .none:
            return
        }
    }
    
    
    // Paginación de los mangas por categoría. Necesita del Switch también para poder seguir paginando con la misma función correspondiente.
    func isLastMangaByCategory(manga: Manga, subcategory: String) {
        if mangasByCategory.last?.id == manga.id {
            pageCategories += 1
            mangasByCategoryTypeSelected(subcategory: subcategory)
        }
    }
    
    
    // Funciones que llaman al listado de subcategorías de acuerdo a la categoría seleccionada:
    
    func Genres() {
        mangasByCategory.removeAll()
        Task {
            do {
                let genres = try await interactor.fetchGenres()
                await MainActor.run {
                    self.subcategories = genres
                }
            } catch {
                await MainActor.run {
                    showAlert = true
                    categoriesListError = .fetchGenres
                }
            }
        }
    }
    
    func Demographics() {
        mangasByCategory.removeAll()
        Task {
            do {
                let demographics = try await interactor.fetchDemographics()
                await MainActor.run {
                    self.subcategories = demographics
                }
            } catch {
                await MainActor.run {
                    showAlert = true
                    categoriesListError = .fetchDemographics
                }
            }
        }
    }
    
    func Themes() {
        mangasByCategory.removeAll()
        Task {
            do {
                let themes = try await interactor.fetchThemes()
                await MainActor.run {
                    self.subcategories = themes
                }
            } catch {
                await MainActor.run {
                    showAlert = true
                    categoriesListError = .fetchThemes
                }
            }
        }
    }
    
    
    // Funciones que llaman al listado de mangas de acuerdo a la categoría y subcategoría seleccionada:
    
    func MangasByGenre(genre: String) {
        Task {
            do {
                let mangas = try await interactor.fetchMangasByGenre(genre: genre, page: pageCategories)
                await MainActor.run {
                    self.mangasByCategory += mangas
                }
            } catch {
                await MainActor.run {
                    showAlert = true
                    mangasByCategoryError = .fetchMangasByGenre
                }
            }
        }
    }
    
    
    
    func MangasByDemographic(demographic: String) {
        Task {
            do {
                let mangas = try await interactor.fetchMangasByDemographic(demographic: demographic, page: pageCategories)
                await MainActor.run {
                    self.mangasByCategory += mangas
                }
            } catch {
                await MainActor.run {
                    showAlert = true
                    mangasByCategoryError = .fetchMangasByDemographic
                }
            }
        }
    }
    
    
    
    func MangasByTheme(theme: String) {
        Task {
            do {
                let mangas = try await interactor.fetchMangasByTheme(theme: theme, page: pageCategories)
                await MainActor.run {
                    self.mangasByCategory += mangas
                }
            } catch {
                await MainActor.run {
                    showAlert = true
                    mangasByCategoryError = .fetchMangasByTheme
                }
            }
        }
    }
}

enum categoryType {
    case genres
    case demographics
    case themes
}

// Errores en caso de que falle alguna función para la vista de 'CategoriesListView':

enum CategoriesListErrors : LocalizedError {
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

// Errores en caso de que falle alguna función para la vista de 'MangasByCategoryView':

enum MangasByCategoryErrors: LocalizedError {
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


