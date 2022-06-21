//
//  PopularMovieModel.swift
//  Movieverse
//
//  Created by Mert Gökduman on 18.06.2022.
//

import Foundation

struct PopularMovieModel: Codable {
    
    var page: Int?
    var results: [MovieModel]?
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
    
    func getResult() -> [MovieModel] {
        return results~
    }
    
    func getPage() -> Int {
        return page~
    }
}

struct MovieModel: Codable {
    
    var backdropPath, releaseDate: String?
    var genreIds: [Int]?
    var id, voteCount: Int?
    var title, originalLanguage, originalTitle, overview, posterPath: String?
    var popularity, voteAverage: Double?
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
        case id, title
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
