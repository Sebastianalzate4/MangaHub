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
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 0.5)
                )
                .padding()
                
            
            if let volumes = viewmodel.manga.volumes {
                LazyVGrid(columns: flexibleColumns) {
                    ForEach(1...volumes, id: \.self) { volumen in
                        Button {
                            viewmodel.persistPurchasedVolumes(volume: volumen)
                        } label: {
                            Text(String(volumen))
                                .foregroundStyle(.white)
                        }
                        .frame(width: 50, height: 50)
                        .background(viewmodel.volumes.contains(volumen) ? Color.mangaHubColor : Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .alert("Something went wrong", isPresented: $viewmodel.showAlert) {
                            Button("Try again"){
                                viewmodel.persistPurchasedVolumes(volume: volumen)
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
                .padding()
            }
        }


    }
}

#Preview {
    PurchasedVolumesView(viewmodel: DetailFavoriteViewModel(manga: .preview))
}


