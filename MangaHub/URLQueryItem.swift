//
//  URLQueryItem.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/07/24.
//

import Foundation


extension URLQueryItem {
    static func getPage(pageNumber: Int) -> URLQueryItem {
        URLQueryItem(name: "page", value: String(pageNumber))
    }
}
