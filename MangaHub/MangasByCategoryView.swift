//
//  MangasByCategoryView.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/07/24.
//

import SwiftUI

struct MangasByCategoryView: View {
    
    // Esta vista va a mostrar un listado de mangas dependiendo de la categoría y subcategoría seleccionada previamente desde la 'CategoriesListView'.
    
    @StateObject var viewmodel = CategoriesViewModel()
    @Binding var pathCategories: NavigationPath
    var subcategory: String
    var category: CategoryType
    
    var body: some View {
        
        ScrollViewReader { proxy in
            List(viewmodel.mangasByCategory, id: \.uniqueID) { manga in
                NavigationLink(value: manga) {
                    MangaCellView(manga: manga)
                        .onAppear {
                            viewmodel.isLastMangaByCategory(manga: manga, subcategory: subcategory)
                        }
                }
                .id("MangasByCategory")
            }
            .onAppear {
                viewmodel.categoryType = category
                viewmodel.mangasByCategoryTypeSelected(subcategory: subcategory)
            }
            .navigationTitle(subcategory)
            .alert("Something went wrong", isPresented: $viewmodel.showAlert) {
                Button("Try again") {
                    switch viewmodel.lastFunctionCalled {
                    case .mangasByGenre : viewmodel.MangasByGenre(genre: subcategory)
                    case .mangasByTheme : viewmodel.MangasByTheme(theme: subcategory)
                    case .mangasByDemographic : viewmodel.MangasByDemographic(demographic: subcategory)
                    default:
                        break
                    }
                }
                Button("Cancel", role: .cancel){}
            } message: {
                Text(viewmodel.errorMessage)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        pathCategories = NavigationPath()
                    }) {
                        HStack{
                            Text("Restart")
                            Image(systemName: "arrowshape.turn.up.backward.fill")
                        }
                    }
                }
            }
            // Botón flotante que usa el ScrollViewReader para poder ir a una sección específica de la vista identificada con un id.
            .overlay(alignment: .bottomTrailing) {
                Button {
                    withAnimation {
                        proxy.scrollTo("MangasByCategory", anchor: .top)
                    }
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 50, height: 50)
                        Image(systemName: "arrow.up.circle.fill")
                            .resizable()
                            .foregroundColor(Color.mangaHubColor)
                            .frame(width: 50, height: 50)
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MangasByCategoryView(pathCategories: .constant(NavigationPath()),subcategory: "Action", category: .genres)
    }
}


