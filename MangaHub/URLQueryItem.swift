//
//  URLQueryItem.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/07/24.
//

import Foundation


// Función usada para darle valor a la página que será usada como parámetro en la url para la llamada a red. Solo usamos la 'page' porque por defecto queda estipulado que el 'per' (mangas por página) sea 10.
extension URLQueryItem {
    static func getPage(pageNumber: Int) -> URLQueryItem {
        URLQueryItem(name: "page", value: String(pageNumber))
    }
}
