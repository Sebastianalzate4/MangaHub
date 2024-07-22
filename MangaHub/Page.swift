//
//  Page.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 15/07/24.
//

import Foundation

struct Page: Identifiable {
    var id = UUID()
    var tag: Int
    var title: String
    var description: String
    var imageName: String
    
    static var pages: [Page] = [
        Page(tag: 0, title: "Welcome", description: "Welcome to MangaHub! Embark on a manga journey with us. Explore a diverse collection of titles, organize your favorites, and build your personal manga haven. Let's get started!", imageName: "Welcome"),
        Page(tag: 1, title: "Home", description: "Discover a vast library of manga at your fingertips, sort your favorite manga by rating to find the best reads, and search for any manga to add to your personal collection.!", imageName: "Home"),
        Page(tag: 2, title: "Categories", description: "Explore manga categories like genres, demographics, and themes. Select a category to see subcategories and choose one to view related manga titles.", imageName: "Categories"),
        Page(tag: 3, title: "Favorites", description: "Your collection of favorite manga will appear here. Click on any manga to view details and manage your progress. Track volumes read and purchased for each title.", imageName: "Favorites")
    ]
}
