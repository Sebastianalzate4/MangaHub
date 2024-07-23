//
//  JsonDecoder.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/07/24.
//

import Foundation

// Llamado a Red para todos los endpoints:

func fetchDataGeneric<TYPE>(url: URL, type: TYPE.Type) async throws -> TYPE where TYPE: Codable {
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let responseHTTP = response as? HTTPURLResponse else { throw NetworkError.noHTTP }
    
    guard responseHTTP.statusCode == 200 else { throw NetworkError.statuscode(responseHTTP.statusCode) }
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(.customDateFormatter)
    return try decoder.decode(type, from: data)
}

enum NetworkError: Error {
    case noHTTP
    case statuscode(Int)
    
    var errorDescription: String {
        switch self {
        case .noHTTP:
            "The response did not contain valid HTTP information."
        case .statuscode(let code):
            "Request failed with status code \(code)."
        }
    }
}
