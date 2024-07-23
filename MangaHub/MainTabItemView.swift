//
//  MainTabItemView.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/07/24.
//

import SwiftUI

struct MainTabItemView: View {
    
    @State private var selectedIndex : Int = 0
    
    var body: some View {
        
        TabView(selection: $selectedIndex) {
            MangasListView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(0)
            CategoriesListView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Categories")
                }
                .tag(1)
            FavoriteMangasListView()
                .tabItem {
                    Image(systemName: "star")
                    Text("Favorites")
                }
                .tag(2)
        }
        .tint(.mangaHubColor)
        .navigationTitle("Mangas")
    }
}

#Preview {
    MainTabItemView()
}
