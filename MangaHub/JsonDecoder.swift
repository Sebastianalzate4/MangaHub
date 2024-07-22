//
//  JsonDecoder.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/07/24.
//

import Foundation


func getDataGeneric<TYPE>(request: URL, type: TYPE.Type) async throws -> TYPE where TYPE: Codable {
  
        let (data, response) = try await URLSession.shared.data(from: request)
        
        guard let responseHTTP = response as? HTTPURLResponse else {
            print("fallo la response de la generica")
            throw NetworkError.noHTTP
        }
        
        guard responseHTTP.statusCode == 200 else {
            print("fallo el status code de la generica")
            throw NetworkError.statuscode(responseHTTP.statusCode)
        }
        
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
            "No HTTP"
        case .statuscode(let code):
            "NOT FOUND \(code)"
        }
    }
}
