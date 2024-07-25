//
//  MangasListView.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/07/24.
//

import SwiftUI

struct MangasListView: View {
    
    @StateObject var viewmodel = ListViewModel()
    @State private var path = NavigationPath() // path para poder volver a esta vista
    let deviceType = UIDevice.current.userInterfaceIdiom // Dependiendo del dispositivo seleccionado, se realizarán ajustes como el número de columnas en el grid cuando el usuario quiera mostrar los mangas en este formato.
    
    let gridMangas: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let gridMangasiPad: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    
    var body: some View {
        
        NavigationStack(path: $path) {
            
            Group {
                // Si la búsqueda de un manga en red es fallida, mostramos la vista 'MangaUnavailableView'
                if viewmodel.wasSearchSuccessful == false {
                    MangaUnavailableView(systemName: "popcorn.fill", title: "No Mangas Found", subtitle: "We couldn't find any manga called \(viewmodel.searchedText)")
                } else {
                    // Por el contrario, si es exitosa, mostramos la Lista con los resultados, o simplemente todos los mangas del endpoint en formato lista.
                    if viewmodel.isList {
                        List(viewmodel.mangas, id: \.self) { manga in
                            NavigationLink(value: manga) {
                                MangaCellView(manga: manga)
                                    .onAppear {
                                        viewmodel.isLastManga(manga: manga)
                                    }
                            }
                            
                        }
                    } else {
                        ScrollView {
                            // Aquí mostramos el listado en formato Grid y hacemos un ajuste de la cantidad de columnas si estamos en un iPad.
                            LazyVGrid(columns: deviceType == .pad ? gridMangasiPad : gridMangas, spacing: 20) {
                                ForEach(viewmodel.mangas, id: \.self) { manga in
                                    NavigationLink(value: manga) {
                                        VStack {
                                            MangaPosterView(manga: manga, size: .medium)
                                                .overlay(alignment: .bottomTrailing) {
                                                    CustomGaugeView(isPercentage: false, value: manga.score, scale: 10, size: .small)
                                                }
                                            Text(manga.title)
                                                .mangaTextModifier()
                                        }
                                    }
                                    .onAppear {
                                        viewmodel.isLastManga(manga: manga)
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationDestination(for: Manga.self) { manga in
                MangaDetailView(viewmodel: DetailViewModel(manga: manga))
            }
            .navigationDestination(for: Author.self) { author in
                MangasByAuthorView(path: $path, author: author)
            }
            .onChange(of: viewmodel.searchedText) {
                viewmodel.onChangeText()
            }
            .alert("Something went wrong", isPresented: $viewmodel.showAlert) {
                Button("Try again") {
                    switch viewmodel.lastFunctionCalled {
                    case .allMangas:
                        viewmodel.AllMangas()
                    case .bestMangas:
                        viewmodel.BestMangas()
                    case .searchMangas:
                        viewmodel.searchManga(text: viewmodel.searchedText)
                    default:
                        break
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text(viewmodel.errorMessage)
            }
            .searchable(text: $viewmodel.searchedText)
            .navigationTitle("Mangas")
            .toolbar {
                ToolbarItemGroup(placement: .secondaryAction) {
                    Button(action: {
                        viewmodel.showBestMangas()
                    }) {
                        Label("Best Mangas", systemImage: "star.fill")
                    }
                    Button(action: {
                        viewmodel.resetAllMangas()
                    }) {
                        Label("Reset All Mangas", systemImage: "arrow.circlepath")
                    }
                    Button(action: {
                        viewmodel.isList.toggle()
                    }) {
                        Label(viewmodel.isList ? "Change to Grid" : "Change to List", systemImage: viewmodel.isList ? "rectangle.grid.2x2" : "rectangle.grid.1x2")
                    }
                }
            }
        }
    }
}


#Preview("PREVIEW DATA") {
    MangasListView(viewmodel: ListViewModel(interactor: .preview))
}


