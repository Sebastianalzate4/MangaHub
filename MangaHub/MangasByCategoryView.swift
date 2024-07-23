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
    var category: categoryType
    
    var body: some View {
        
        List(viewmodel.mangasByCategory, id: \.self) { manga in
            NavigationLink(value: manga) {
                MangaCellView(manga: manga)
                    .onAppear {
                        viewmodel.isLastMangaByCategory(manga: manga, subcategory: subcategory)
                    }
            }
            
        }
        .onAppear {
            viewmodel.categoryType = category
            viewmodel.mangasByCategoryTypeSelected(subcategory: subcategory)
        }
        .navigationTitle(subcategory)
        .alert("Something went wrong", isPresented: $viewmodel.showAlert, presenting: viewmodel.mangasByCategoryError, actions: { error in
            Button("Try again") {
                switch error {
                case .fetchMangasByGenre : viewmodel.MangasByGenre(genre: subcategory)
                case .fetchMangasByTheme : viewmodel.MangasByTheme(theme: subcategory)
                case .fetchMangasByDemographic : viewmodel.MangasByDemographic(demographic: subcategory)
                }
            }
            Button {
                viewmodel.showAlert = false
            } label: {
                Text("Cancel")
            }
        }, message: {
            Text($0.errorDescription)
        })
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
    }
}


#Preview {
    NavigationStack {
        MangasByCategoryView(pathCategories: .constant(NavigationPath()),subcategory: "Action", category: .genres)
    }
}


