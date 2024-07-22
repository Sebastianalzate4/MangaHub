//
//  FavoriteMangaDetailView.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/07/24.
//

import SwiftUI

struct FavoriteMangaDetailView: View {
    
    @StateObject var viewmodel: DetailFavoriteViewModel
    
    @State var isExpanded: Bool = false
    @State private var showVolumes : Bool = false
    
    var body: some View {
        
        ScrollView {
 
            Group{
                if let volumes = viewmodel.manga.volumes {
                    
                    Text("Reading Section")
                        .font(.title)
                        .bold()
                        .padding()
                    
                    VStack {
                        Text("Total Volumes:")
                            .padding()
                            .font(.title3)
                            .bold()
                        
                        Text("\(volumes)")
                            .font(.title)
                            .bold()
                    }
                    
                    CustomGaugeView(value: Double(viewmodel.reading), scale: Double(volumes), isPercentage: true, size: .large)
                        .padding()
                    
 
                    Text("Volumes Read:")
                        .padding()
                        .font(.title3)
                        .bold()

    
                    HStack {
                        Spacer()
                       
                        Button {
                            viewmodel.reading -= 1
                            viewmodel.persistReadingVolume()
                        } label: {
                            Image(systemName: "minus")
                                .foregroundColor(viewmodel.reading <= 0 ? .gray : .white)
                                .frame(width: 60, height: 60)
                                .background(viewmodel.reading <= 0 ? Color.gray.opacity(0.3) : Color.mangaHubColor)
                                .clipShape(Circle())
                        }
                        .disabled(viewmodel.reading <= 0)
                       
                        Spacer()
                        
                        Text("\(viewmodel.reading)")
                            .font(.title)
                            .bold()
                        
                        Spacer()
                        
                        Button {
                            viewmodel.reading += 1
                            viewmodel.persistReadingVolume()
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(viewmodel.reading >= volumes ? .gray : .white)
                                .frame(width: 60, height: 60)
                                .background(viewmodel.reading >= volumes ? Color.gray.opacity(0.3) : Color.mangaHubColor)
                                .clipShape(Circle())
                        }
                        .disabled(viewmodel.reading >= volumes)
                        
                        Spacer()
                    }
                    
                    Slider(value: Binding(
                        get: { Double(viewmodel.reading) },
                        set: { newValue in
                            viewmodel.reading = Int(newValue)
                            viewmodel.persistReadingVolume()
                        }
                    ), in: 0...Double(volumes))
                    .tint(Color.mangaHubColor)
                    .padding()
                    
                    Divider()
                        .padding()
                    
                    Text("Purchase Section")
                        .font(.title)
                        .bold()
                        .padding()
                    
                    CustomGaugeView(value: Double(viewmodel.manga.purchasedVolumes.count), scale: Double(volumes), isPercentage: true, size: .large)
                        .padding()
                    
                    HStack {
                        VStack {
                            Text("Purchased:")
                                .padding()
                                .font(.title3)
                                .bold()
                            
                            Text("\(viewmodel.manga.purchasedVolumes.count)")
                                .font(.title)
                                .bold()
                        }
                        
                        VStack {
                            Text("Total Volumes:")
                                .padding()
                                .font(.title3)
                                .bold()
                            
                            Text("\(volumes)")
                                .font(.title)
                                .bold()
                        }
                    }
                    
                    
                    
                    Button {
                        if viewmodel.manga.volumes != nil {
                            showVolumes = true
                        }
                    } label: {
                        Text("+ Add New")
                            .font(.subheadline)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                            .foregroundColor(.white)
                            .background(Color.mangaHubColor)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.horizontal)
                    }
                    
                } else {
                    VStack {
                        MangaUnavailableView(systemName: "xmark.circle.fill", title: "Ooops!", subtitle: "This manga does not have volumes registered")
                        
                    }
                    .padding(.init(top: 150, leading: 10, bottom: 150, trailing: 10))
                }
            }
            
            
            Divider()
                .padding()
            
            Text("Details Section")
                .font(.title)
                .bold()
                .padding()
            
            DetailsSectionView(manga: viewmodel.manga)
            
            
        }
        .navigationTitle(viewmodel.manga.title)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                ShareLink(item: viewmodel.manga.validURL ) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
            }
        }
        .sheet(isPresented: $showVolumes) {
            PurchasedVolumesView(viewmodel: viewmodel)
                .presentationDetents([.medium, .large])
        }
        .alert("Something went wrong", isPresented: $viewmodel.showAlert) {
            Button("Try again"){
                viewmodel.persistReadingVolume()
            }
            Button {
                viewmodel.showAlert = false
            } label: {
                Text("Cancel")
            }
        } message: {
            Text(viewmodel.errorMessage)
        }
    }
}


#Preview {
    NavigationStack {
        FavoriteMangaDetailView(viewmodel: DetailFavoriteViewModel(manga: .preview))
    }
}

