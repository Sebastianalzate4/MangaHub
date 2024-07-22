//
//  MangasListView.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/07/24.
//

import SwiftUI

struct MangasListView: View {
    
    @StateObject var viewmodel = ListViewModel()
    
    @State private var path = NavigationPath()
    
    let gridMangas: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let gridMangasiPad: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let deviceType = UIDevice.current.userInterfaceIdiom
    
    
    var body: some View {
        
        NavigationStack(path: $path) {
            
            Group {
                if viewmodel.successSearch == false {
                    MangaUnavailableView(systemName: "popcorn.fill", title: "No Mangas Found", subtitle: "We couldn't find any manga called \(viewmodel.searchedText)")
                } else {
                    if viewmodel.isList {
                        List(viewmodel.mangas) { manga in
                            NavigationLink(value: manga) {
                                MangaCellView(manga: manga)
                                    .onAppear {
                                        viewmodel.isLastItem(manga: manga)
                                    }
                            }
                        }
                    } else {
                        ScrollView {
                            LazyVGrid(columns: deviceType == .pad ? gridMangasiPad : gridMangas, spacing: 20) {
                                ForEach(viewmodel.mangas) { manga in
                                    NavigationLink(value: manga) {
                                        VStack {
                                            MangaPosterView(manga: manga, size: .large)
                                                .overlay(alignment: .bottomTrailing) {
//                                                    MangaScoreView(manga: manga)
                                                    CustomGaugeView(value: manga.score, scale: 10, isPercentage: false, size: .small)
                                                }
                                            Text(manga.title)
                                                .font(.system(.headline, design: .rounded))
                                                .foregroundColor(Color.white)
                                                .multilineTextAlignment(.center)
                                                .lineLimit(1)
                                                .padding(.horizontal, 8)
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 30)
                                                .background(Color.mangaHubColor)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(Color.black, lineWidth: 0.5))
                                        }
                                    }
                                    .onAppear {
                                        viewmodel.isLastItem(manga: manga)
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
            .alert("Something went wrong", isPresented: $viewmodel.showAlert, presenting: viewmodel.myError) { error in
                Button("Try again") {
                    switch error {
                    case .allMangasError: viewmodel.fetchAllMangas()
                    case .bestMangasError: viewmodel.fetchBestMangas()
                    case .searchMangasError: viewmodel.search(text: viewmodel.searchedText)
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
            .alert("Something Went Wrong", isPresented: $viewmodel.showAlertNetwork) {
                Button("Cancel") {
                    viewmodel.showAlertNetwork = false
                }
            } message: {
                Text(viewmodel.errorMessage)
            }
            .searchable(text: $viewmodel.searchedText)
//            .refreshable {
//                switch viewmodel.
//                viewmodel.fetchAllMangas()
//            }
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


//#Preview("PRODUCTION DATA") {
//    MangasListView()
//}


