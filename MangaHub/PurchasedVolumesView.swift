//
//  PurchasedVolumesView.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/07/24.
//

import SwiftUI

struct PurchasedVolumesView: View {
    
    @ObservedObject var viewmodel: DetailFavoriteViewModel
    
    let flexibleColumns : [GridItem] = [GridItem(.flexible()) , GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            
            Text("Select the volumes you have purchased")
                .padding()
                .font(.system(.title, design: .rounded))
                .bold()
                .foregroundColor(Color.white)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .background(Color.mangaHubColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 0.5)
                }
                .padding()
            
            // Grid creado a partir del total de volúmenes que tiene el manga.
            if let volumes = viewmodel.manga.volumes {
                LazyVGrid(columns: flexibleColumns) {
                    ForEach(1...volumes, id: \.self) { volume in
                        Button {
                            // Cada uno de los elementos del grid es un botón para poder ser pulsado y realizar la persistencia de ese volúmen en particular o eliminarlo en su defecto en caso de ya haber sido pulsado previamente.
                            viewmodel.persistPurchasedVolumes(volume: volume)
                        } label: {
                            Text(String(volume))
                                .foregroundStyle(.white)
                        }
                        .frame(width: 50, height: 50)
                        .background(viewmodel.volumes.contains(volume) ? Color.mangaHubColor : Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .alert("Something went wrong", isPresented: $viewmodel.showAlert) {
                            Button("Try again"){
                                viewmodel.persistPurchasedVolumes(volume: volume)
                            }
                            Button("Cancel", role: .cancel){}
                        } message: {
                            Text(viewmodel.errorMessage)
                        }
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    PurchasedVolumesView(viewmodel: DetailFavoriteViewModel(manga: .preview))
}


