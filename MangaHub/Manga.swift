//
//  Manga.swift
//  MangaHub
//
//  Created by Sebastian Alzate on 11/07/24.
//

import Foundation

struct Manga: Codable, Identifiable, Hashable {
    let score: Double
    let sypnosis: String?
    let demographics: [Demographic]
    let status: String
    let background: String?
    let startDate: Date?
    let url: String
    let endDate: Date?
    let id: Int
    let genres: [Genre]
    let titleEnglish: String?
    let title: String
    let mainPicture: String
    let authors: [Author]
    let chapters: Int?
    let volumes: Int?
    let titleJapanese: String?
    let themes: [Theme]
    
    // Nuevas propiedades para mi modelo de presentación:
    var purchasedVolumes: [Int]
    var readingVolume: Int
    var id2 = UUID()
    
    // Nuevas propiedades a patir de propiedades existentes para ser usadas en las vistas: 
    var formattedScore: String {
        score.formatted(.number.precision(.fractionLength(1)))
    }
    
    var formattedStatus: String {
        if status == "finished" {
            return "Finished"
        } else {
            return "Currently Publishing"
        }
    }
    
    var formattedVolumes: String {
        volumes.map { "\($0)" } ?? "No Volumes Registered"
    }

    var formattedChapters: String {
        chapters.map { "\($0)" } ?? "No Chapters Registered"
    }
    
    var formattedStartDate: String {
        startDate?.formatted(.dateTime.year()) ?? "No Date Registered"
    }
    
    var formattedEndDate: String {
        endDate?.formatted(.dateTime.year()) ?? "Currently Active"
    }
    
    var mainPictureURL: URL {
        let urlString = mainPicture.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
        return URL(string: urlString)!
    }
    
    var validURL: URL {
        let urlString = url.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
        return URL(string: urlString)!
    }
}
