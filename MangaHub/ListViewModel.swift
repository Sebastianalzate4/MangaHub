//
//  ListViewModel.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/07/24.
//

import Foundation

final class ListViewModel: ObservableObject {
    
    @Published var mangas: [Manga] = []
    @Published var mangasByAuthor: [Manga] = []
    
    @Published var searchedText = ""
    @Published var wasSearchSuccessful = true
    @Published var isSearchedNeeded = false
    @Published var isBestMangaSelected = false
    @Published var isList = true
    
    @Published var errorMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var mangasListError : MangasListErrors?
    @Published var showAlertNetwork: Bool = false
    
    var page = 1
    var pageAuthor = 1
    var mangasPerPage = 10
    var searchTask: Task<Void, Never>?
    
    private let interactor: NetworkProtocol
    
    init(interactor: NetworkProtocol = NetworkInteractor()) {
        self.interactor = interactor
        AllMangas()
    }
    
    // Funciones que llaman a red para cargar los Mangas correspondientes y darle valor a los arrays marcados como @Published (mangas y magasByAuthor)
    
    func AllMangas() {
        Task {
            do {
                let mangas = try await interactor.fetchAllMangasPaginated(page: page, mangasPerPage: mangasPerPage)
                await MainActor.run {
                    self.mangas += mangas
                }
            }  catch {
                await MainActor.run {
                    showAlert = true
                    mangasListError = .allMangasError
                }
            }
        }
    }
    
    
    func BestMangas() {
        Task {
            do {
                let mangas = try await interactor.fetchBestMangas(page: page, mangasPerPage: mangasPerPage)
                await MainActor.run {
                    self.mangas += mangas
                }
            } catch {
                await MainActor.run {
                    showAlert = true
                    mangasListError = .bestMangasError
                }
            }
        }
    }
    
    func MangasByAuthor(idAuthor: String) {
        Task {
            do {
                let mangas = try await interactor.fetchMangasByAuthor(idAuthor: idAuthor, page: pageAuthor, mangasPerPage: mangasPerPage)
                await MainActor.run {
                    mangasByAuthor += mangas
                }
            } catch {
                await MainActor.run {
                    errorMessage = "Error loading mangas by author"
                    showAlert = true
                }
            }
        }
    }
    
    // Funciones que realizan la paginación de los mangas:
    
    func isLastManga(manga: Manga) {
        if mangas.last?.id == manga.id {
            page += 1
            // Si no estamos buscando un manga y no hemos seleccionado los BestMangas -> Llamamos a todos los mangas en su siguiente página.
            if isSearchedNeeded == false && isBestMangaSelected == false {
                AllMangas()
                // Si buscamos un manga y no hemos seleccionado los BestMangas -> Llamamos a los mangas buscados en su siguiente página.
            } else if isSearchedNeeded == true && isBestMangaSelected == false || isSearchedNeeded == true && isBestMangaSelected == true {
                Task {
                    do {
                        let mangas = try await interactor.fetchSearchedMangas(text: searchedText, page: page)
                        await MainActor.run {
                            self.mangas += mangas
                        }
                    } catch {
                        await MainActor.run {
                            mangasListError = .searchMangasError
                            showAlert = true
                        }
                    }
                }
                // Si no hemos buscado un manga y hemos seleccionado los BestMangas -> Llamamos a los mejores mangas en su siguiente página.
            } else if isSearchedNeeded == false && isBestMangaSelected == true {
                BestMangas()
            }
        }
    }
    
    func isLastMangaByAuthor(manga: Manga, idAuthor: String) {
        if mangasByAuthor.last?.id == manga.id {
            pageAuthor += 1
            MangasByAuthor(idAuthor: idAuthor)
        }
    }
    
    
    // Función que realiza la búsqueda en red de los mangas que contengan el texto ingresado por el usuario:
    
    func searchManga(text: String) {
        searchTask?.cancel()
        searchTask = nil
        searchTask = Task {
            do {
                try await Task.sleep(for: .milliseconds(400))
                do {
                    let searchedMangas = try await interactor.fetchSearchedMangas(text: text, page: page)
                    await MainActor.run {
                        mangas.removeAll()
                        mangas = searchedMangas
                        if mangas.isEmpty {
                            wasSearchSuccessful.toggle()
                        }
                    }
                } catch {
                    await MainActor.run {
                        mangasListError = .searchMangasError
                        showAlert = true
                    }
                }
            } catch {
                print("Search Canceled")
            }
        }
    }
    
    // Función que vigila los cambios del texto ingresado para la búsqueda del usuario. Si el campo de texto está vacío, es porque hemos borrado lo escrito y cancelamos la búsqueda, por lo tanto, reinciamos todo y volvemos a mostrar todos los mangas. Por el contrario, si el campo de texto no está vacío es porque se requiere una búsqueda, así que llamamos a los mangas que contengan el texto.
    
    func onChangeText() {
        wasSearchSuccessful = true // variable que controla si se muestra o no la 'MangaUnavailableView' en caso de no encontrar resultados en la búsqueda de mangas que contengan el texto ingresado por el usuario. 
        if searchedText.isEmpty {
            searchTask?.cancel()
            mangas.removeAll()
            isSearchedNeeded = false
            isBestMangaSelected = false
            page = 1
            AllMangas()
        } else {
            mangas.removeAll()
            isSearchedNeeded = true
            page = 1
            searchManga(text: searchedText)
        }
    }
    
    
    // Función que reestablece los valores para mostrar los mejores mangas desde el principio.
    func showBestMangas() {
        mangas.removeAll()
        page = 1
        isBestMangaSelected = true
        BestMangas()
    }
    
    // Función que reestablece los valores para mostrar de nuevo todos los mangas desde el principio.
    func resetAllMangas() {
        mangas.removeAll()
        page = 1
        isSearchedNeeded = false
        isBestMangaSelected = false
        AllMangas()
    }
}

// Errores en caso de que falle alguna función.

enum MangasListErrors : LocalizedError {
    case allMangasError
    case bestMangasError
    case searchMangasError
    
    var errorDescription: String {
        switch self {
        case .allMangasError:
            "Error loading mangas"
        case .bestMangasError:
            "Error loading best mangas"
        case .searchMangasError:
            "Error searching the manga"
        }
    }
}
