//
//  LaunchScreenView.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/07/24.
//

import SwiftUI

struct LaunchScreenView: View {
    
    var body: some View {
        
        ZStack {
            Color.mangaHubColor
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("MangaHubLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                
                Text("MangaHub")
                    .font(.title)
                    .foregroundStyle(.black)
                    .bold()
                
                ProgressView()
                    .controlSize(.extraLarge)
                    .scaledToFit()
            }
        }
    }
}

#Preview {
    LaunchScreenView()
}
