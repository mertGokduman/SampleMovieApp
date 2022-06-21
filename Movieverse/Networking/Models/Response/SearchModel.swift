//
//  SearchModel.swift
//  Movieverse
//
//  Created by Mert Gökduman on 18.06.2022.
//

import Foundation

struct SearchModel: Codable {
    
    var page: Int?
    var results: [SearchResult]?
    var totalPages, totalResults: Int?
    var success: Bool?
    var statusCode: Int?
    var statusMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case page, results, success
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
    
    func getResult() -> [SearchResult] {
        return results~
    }
    
    func getPage() -> Int {
        return page~
    }
}

struct SearchResult: Codable {
    
    var id: Int?
    var name, title, overview, mediaType: String?
    var posterPath, profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, title, overview
        case mediaType = "media_type"
        case posterPath = "poster_path"
        case profilePath = "profile_path"
    }
}
