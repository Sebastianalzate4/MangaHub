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
    @Published var isSearchNeeded = false
    @Published var isBestMangaSelected = false
    @Published var isList = true
    
    @Published var errorMessage: String = ""
    @Published var lastFunctionCalled : MangaListFunctions? // Rastreo de cuál fue la última función llamada para establecerla en el switch del alert en la vista.
    @Published var showAlert: Bool = false
    
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
        lastFunctionCalled = .allMangas
        Task {
            do {
                let mangas = try await interactor.fetchAllMangasPaginated(page: page, mangasPerPage: mangasPerPage)
                await MainActor.run {
                    self.mangas += mangas
                }
            }  catch {
                await MainActor.run {
                    switch error {
                    case let networkError as NetworkError:
                        showAlert = true
                        errorMessage = "It was not possible to load the list of mangas. \(networkError.networkErrorDescription)"
                    default:
                        showAlert = true
                        errorMessage = "An unknown error has occurred. Please check your internet connection"
                    }
                }
            }
        }
    }
    
    
    func BestMangas() {
        lastFunctionCalled = .bestMangas
        Task {
            do {
                let mangas = try await interactor.fetchBestMangas(page: page, mangasPerPage: mangasPerPage)
                await MainActor.run {
                    self.mangas += mangas
                }
            } catch {
                await MainActor.run {
                    switch error {
                    case let networkError as NetworkError:
                        showAlert = true
                        errorMessage = "It was not possible to load best mangas list. \(networkError.networkErrorDescription)"
                    default:
                        showAlert = true
                        errorMessage = "An unknown error has occurred. Please check your internet connection"
                    }
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
                    switch error {
                    case let networkError as NetworkError:
                        showAlert = true
                        errorMessage = "It was not possible to load the mangas of this author. \(networkError.networkErrorDescription)"
                    default:
                        showAlert = true
                        errorMessage = "An unknown error has occurred. Please check your internet connection"
                    }
                }
            }
        }
    }
    
    // Funciones que realizan la paginación de los mangas:
    
    func isLastManga(manga: Manga) {
        if mangas.last?.id == manga.id {
            page += 1
            // Si no estamos buscando un manga y no hemos seleccionado los BestMangas -> Llamamos a todos los mangas en su siguiente página.
            if isSearchNeeded == false && isBestMangaSelected == false {
                AllMangas()
                // Si buscamos un manga y no hemos seleccionado los BestMangas -> Llamamos a los mangas buscados en su siguiente página.
            } else if isSearchNeeded == true && isBestMangaSelected == false || isSearchNeeded == true && isBestMangaSelected == true {
                Task {
                    do {
                        let mangas = try await interactor.fetchSearchedMangas(text: searchedText, page: page)
                        await MainActor.run {
                            self.mangas += mangas
                        }
                    } catch {
                        await MainActor.run {
                            switch error {
                            case let networkError as NetworkError:
                                showAlert = true
                                errorMessage = "It was not possible to show more results. \(networkError.networkErrorDescription)"
                            default:
                              break
                            }
                        }
                    }
                }
                // Si no hemos buscado un manga y hemos seleccionado los BestMangas -> Llamamos a los mejores mangas en su siguiente página.
            } else if isSearchNeeded == false && isBestMangaSelected == true {
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
        lastFunctionCalled = .searchMangas
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
                        switch error {
                        case let networkError as NetworkError:
                            showAlert = true
                            errorMessage = "It was not possible to execute the search. \(networkError.networkErrorDescription)"
                        default:
                            // Aquí entraría si ocurre cualquier otro error no especificado como la cancelación de la tarea, ausencia de conexión a internet, etc.
                          break // Hago un break porque de lo contrario, salta una alerta cada vez que se cancela una tarea que ya empezó luego del sleep.
                        }
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
            isSearchNeeded = false
            isBestMangaSelected = false
            page = 1
            AllMangas()
        } else {
            mangas.removeAll()
            isSearchNeeded = true
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
        isSearchNeeded = false
        isBestMangaSelected = false
        AllMangas()
    }
}


// Representa las funciones usadas en 'MangaListView' para poder hacer una trazabilidad de cuál fue la última función en ser llamada.
enum MangaListFunctions {
    case allMangas
    case bestMangas
    case searchMangas
}
