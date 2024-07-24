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
                // Si el manga tiene volúmenes, podremos mostrar las vistas que son utilizadas como panel de control para llevar registro de la trazabilidad de los mangas comprados y leídos.
                
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
                    
                    CustomGaugeView(isPercentage: true, value: Double(viewmodel.readingValue), scale: Double(volumes), size: .large)
                        .padding()
                    
                    Text("Volumes Read:")
                        .padding()
                        .font(.title3)
                        .bold()
                    
                    // Botones de + y - para aumentar o disminuir los volúmenes leídos y persistir el cambio cuando se pulsen.
                    HStack {
                        Spacer()
                        
                        Button {
                            viewmodel.readingValue -= 1
                            viewmodel.persistReadingVolume()
                        } label: {
                            Image(systemName: "minus")
                                .foregroundColor(viewmodel.readingValue <= 0 ? .gray : .white)
                                .frame(width: 60, height: 60)
                                .background(viewmodel.readingValue <= 0 ? Color.gray.opacity(0.3) : Color.mangaHubColor)
                                .clipShape(Circle())
                        }
                        .disabled(viewmodel.readingValue <= 0)
                        
                        Spacer()
                        
                        Text("\(viewmodel.readingValue)")
                            .font(.title)
                            .bold()
                        
                        Spacer()
                        
                        Button {
                            viewmodel.readingValue += 1
                            viewmodel.persistReadingVolume()
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(viewmodel.readingValue >= volumes ? .gray : .white)
                                .frame(width: 60, height: 60)
                                .background(viewmodel.readingValue >= volumes ? Color.gray.opacity(0.3) : Color.mangaHubColor)
                                .clipShape(Circle())
                        }
                        .disabled(viewmodel.readingValue >= volumes)
                        
                        Spacer()
                    }
                    
                    // Slider para que el usuario pueda aumentar o disminuir el número de volúmenes leídos sin tener que pulsar tantas veces los botones de + y -
                    // Utilicé un Binding para vincular directamente el Slider con el readingValue. De este modo, cualquier cambio se verá reflejado en el viewmodel y persistido.
                    Slider(value: Binding(
                        get: { Double(viewmodel.readingValue) },
                        set: { newValue in
                            viewmodel.readingValue = Int(newValue)
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

                    CustomGaugeView(isPercentage: true, value: Double(viewmodel.manga.purchasedVolumes.count), scale: Double(volumes), size: .large)
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
                    
                    // Botón que hace aparecer el modal para poder seleccionar los volúmenes que el usuario ha comprado.
                    Button {
                        if viewmodel.manga.volumes != nil {
                            showVolumes = true
                        }
                    } label: {
                        Text("+ Add New")
                            .mangaHubButton(color: Color.mangaHubColor)
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
            
            // Reutilización de la vista con el Form que contiene todo los datos del manga.
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

