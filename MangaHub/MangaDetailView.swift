//
//  MangaDetailView.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/07/24.
//

import SwiftUI

struct MangaDetailView: View {
    
    @StateObject var viewmodel: DetailViewModel
    @State var isExpanded: Bool = false
    @State private var showVolumes : Bool = false
    let deviceType = UIDevice.current.userInterfaceIdiom
    
    var body: some View {
        
        ScrollView {
            
            VStack {
                MangaPosterView(manga: viewmodel.manga, size: .large)
                .padding()
                
                Text(viewmodel.manga.title)
                    .font(.title)
                    .bold()
                
                
                // Botón para convertir un Manga en Favorito.
                Button {
                    viewmodel.saveFavorite()
                    viewmodel.isDisable = true
                } label: {
                    Label(viewmodel.isDisable ? "Added to Favorites" : "Add me to Favorites", systemImage: viewmodel.isDisable ? "checkmark.circle" : "star")
                }
                .mangaHubButton(color: viewmodel.isDisable ? Color.gray : Color.mangaHubColor)
                .disabled(viewmodel.isDisable)
                .animation(.interactiveSpring(response: 0.5, dampingFraction: 1, blendDuration: 1), value: viewmodel.isDisable)
                
                // Vista para filtrar la información que el usuario quiera ver.
                FilterDetailView(viewmodel: viewmodel)
                    .padding(.init(top: 10, leading: 10, bottom: 0, trailing: 10))
                
            }
        }
        .onAppear {
            viewmodel.checkFavorite()
        }
        .alert("Something went wrong", isPresented: $viewmodel.showAlert) {
            Button("Try again") {
                switch viewmodel.lastFunctionCalled {
                case .checkFavorite: viewmodel.checkFavorite()
                case .saveFavorite: viewmodel.saveFavorite()
                default: break
                }
            }
            Button("Cancel", role: .cancel){}
        } message: {
            Text(viewmodel.errorMessage)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                ShareLink(item: viewmodel.manga.validURL) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MangaDetailView(viewmodel: DetailViewModel(manga: .preview))
    }
}




