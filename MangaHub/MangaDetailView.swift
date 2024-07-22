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
    
    var body: some View {
        ScrollView {
            AsyncImage(url: viewmodel.manga.mainPictureURL) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .frame(width: 250, height: 250)
            } placeholder: {
                ProgressView()
                    .controlSize(.extraLarge)
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .frame(width: 250, height: 250)
            }
            .padding()
            
            Text(viewmodel.manga.title)
                .font(.title)
                .bold()
            Text(viewmodel.manga.sypnosis ?? "")
                .multilineTextAlignment(.leading)
                .lineLimit(isExpanded ? nil : 5)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
            Button {
                withAnimation {
                    isExpanded.toggle()
                }
            } label: {
                Text(isExpanded ? "Show Less" : "Read More")
            }
            
            Link("Go to manga website", destination: viewmodel.manga.validURL)
            
            
            // BOTON DE FAVORITOS
            Button {
                viewmodel.saveFavourite()
                viewmodel.isDisable = true
            } label: {
                Label(viewmodel.isDisable ? "Added to Favourites" : "Make me Favourite", systemImage: viewmodel.isDisable ? "checkmark.circle" : "star")
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
            .padding()
            .disabled(viewmodel.isDisable)
            
            HStack{
                Text("Authors").bold().font(.title2)
                    .padding(.leading)
                Spacer()
            }
            ScrollView(.horizontal){
                HStack(alignment: .center) {
                    ForEach(viewmodel.manga.authors) { author in
                        NavigationLink(value: author) {
                            
                            Text(author.authorCompleteName)
                                .padding(.leading)
                                .padding(.bottom)
                        }
                    }
                }
            }
        }
        .navigationTitle(viewmodel.manga.title)
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
                ShareLink(item: viewmodel.manga.validURL ) {
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


