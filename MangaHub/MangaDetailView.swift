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
    
    let flexibleColumns : [GridItem] = [GridItem(.flexible()) , GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    let deviceType = UIDevice.current.userInterfaceIdiom
    
    var body: some View {
        
        ScrollView {
            
            VStack {
                AsyncImage(url: viewmodel.manga.mainPictureURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .frame(width: 350, height: 350)
                } placeholder: {
                    ProgressView()
                        .controlSize(.extraLarge)
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .frame(width: 350, height: 350)
                }
                .padding()
                
                Text(viewmodel.manga.title)
                    .font(.title)
                    .bold()
                
                
                // BOTON DE FAVORITOS
                Button {
                    viewmodel.saveFavourite()
                    viewmodel.isDisable = true
                } label: {
                    Label(viewmodel.isDisable ? "Added to Favourites" : "Make me Favourite", systemImage: viewmodel.isDisable ? "checkmark.circle" : "star")
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
     
                

                FilterDetailView(viewmodel: viewmodel)
                    .padding(.init(top: 10, leading: 10, bottom: 0, trailing: 10))

            }
        }
        .onAppear {
            viewmodel.checkFavourite()
        }
        .alert("Something went wrong", isPresented: $viewmodel.showAlert, presenting: viewmodel.myError) { error in
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




