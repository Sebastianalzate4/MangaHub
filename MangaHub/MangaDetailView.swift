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
                    viewmodel.saveFavourite()
                    viewmodel.isDisable = true
                } label: {
                    Label(viewmodel.isDisable ? "Added to Favourites" : "Add me to Favourites", systemImage: viewmodel.isDisable ? "checkmark.circle" : "star")
                }
                .font(.system(.headline, design: .rounded))
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .foregroundColor(.white)
                .background(viewmodel.isDisable ? Color.gray : Color.mangaHubColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
                .disabled(viewmodel.isDisable)
                .animation(.interactiveSpring(response: 0.5, dampingFraction: 1, blendDuration: 1), value: viewmodel.isDisable)
                
                // Vista para filtrar la información que el usuario quiera ver.
                FilterDetailView(viewmodel: viewmodel)
                    .padding(.init(top: 10, leading: 10, bottom: 0, trailing: 10))
                
            }
        }
        .onAppear {
            viewmodel.checkFavourite()
        }
        .alert("Something went wrong", isPresented: $viewmodel.showAlert, presenting: viewmodel.mangaDetailError) { error in
            Button("Try again") {
                switch error {
                case .checkFavourite: viewmodel.checkFavourite()
                case .saveFavourite: viewmodel.saveFavourite()
                }
            }
            Button {
                viewmodel.showAlert = false
            } label: {
                Text("Cancel")
            }
        } message: {
            Text($0.errorDescription)
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




