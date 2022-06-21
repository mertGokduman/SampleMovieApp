//
//  MovieDetailModel.swift
//  Movieverse
//
//  Created by Mert Gökduman on 18.06.2022.
//

import Foundation

struct DetailsTVModel: Codable {
    
    var backdropPath, releaseDate: String?
    var genres: [Genre]?
    var homepage, imdbID, title, overview, posterPath, status: String?
    var id, voteCount, runtime: Int?
    var voteAverage: Double?
    var success: Bool?
    var statusCode: Int?
    var statusMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case genres, homepage, id, title, overview, success, runtime
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case imdbID = "imdb_id"
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

struct Genre: Codable {
    
    var id: Int?
    var name: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
    }
}
