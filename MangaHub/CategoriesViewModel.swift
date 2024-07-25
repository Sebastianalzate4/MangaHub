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
    @Published var categoryType: CategoryType?
    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var lastFunctionCalled : MangasByCategoryFunctions?
    
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
                    switch error {
                    case let networkError as NetworkError:
                        showAlert = true
                        errorMessage = "Error loading Genres. \(networkError.networkErrorDescription)"
                    default:
                        showAlert = true
                        errorMessage = "An unknown error has occurred. Please check your internet connection"
                    }
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
                    switch error {
                    case let networkError as NetworkError:
                        showAlert = true
                        errorMessage = "Error loading Demographics. \(networkError.networkErrorDescription)"
                    default:
                        showAlert = true
                        errorMessage = "An unknown error has occurred. Please check your internet connection"
                    }
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
                    switch error {
                    case let networkError as NetworkError:
                        showAlert = true
                        errorMessage = "Error loading Themes. \(networkError.networkErrorDescription)"
                    default:
                        showAlert = true
                        errorMessage = "An unknown error has occurred. Please check your internet connection"
                    }
                }
            }
        }
    }
    
    
    // Funciones que llaman al listado de mangas de acuerdo a la categoría y subcategoría seleccionada:
    
    func MangasByGenre(genre: String) {
        lastFunctionCalled = .mangasByGenre
        Task {
            do {
                let mangas = try await interactor.fetchMangasByGenre(genre: genre, page: pageCategories)
                await MainActor.run {
                    self.mangasByCategory += mangas
                }
            } catch {
                await MainActor.run {
                    switch error {
                    case let networkError as NetworkError:
                        showAlert = true
                        errorMessage = "Error loading mangas by genre. \(networkError.networkErrorDescription)"
                    default:
                        showAlert = true
                        errorMessage = "An unknown error has occurred. Please check your internet connection"
                    }
                }
            }
        }
    }
    
    
    func MangasByDemographic(demographic: String) {
        lastFunctionCalled = .mangasByDemographic
        Task {
            do {
                let mangas = try await interactor.fetchMangasByDemographic(demographic: demographic, page: pageCategories)
                await MainActor.run {
                    self.mangasByCategory += mangas
                }
            } catch {
                await MainActor.run {
                    switch error {
                    case let networkError as NetworkError:
                        showAlert = true
                        errorMessage = "Error loading mangas by demographic. \(networkError.networkErrorDescription)"
                    default:
                        showAlert = true
                        errorMessage = "An unknown error has occurred. Please check your internet connection"
                    }
                }
            }
        }
    }
    

    func MangasByTheme(theme: String) {
        lastFunctionCalled = .mangasByTheme
        Task {
            do {
                let mangas = try await interactor.fetchMangasByTheme(theme: theme, page: pageCategories)
                await MainActor.run {
                    self.mangasByCategory += mangas
                }
            } catch {
                await MainActor.run {
                    switch error {
                    case let networkError as NetworkError:
                        showAlert = true
                        errorMessage = "Error loading mangas by theme. \(networkError.networkErrorDescription)"
                    default:
                        showAlert = true
                        errorMessage = "An unknown error has occurred. Please check your internet connection"
                    }
                }
            }
        }
    }
}

// Usado para controlar el cambio de color de los botones en la vista 'CategoriesListView' al ser pulsados, controla también la alerta en la vista para identificar cuál función llamar en el botón de "Try Again" y además, establece el valor pasado como category a la siguiente vista 'MangasByCategory'.

enum CategoryType {
    case genres
    case demographics
    case themes
}


// Representa las funciones usadas en 'MangaByCategoryView' para poder hacer una trazabilidad de cuál fue la última función en ser llamada.

enum MangasByCategoryFunctions {
    case mangasByGenre
    case mangasByDemographic
    case mangasByTheme
}


