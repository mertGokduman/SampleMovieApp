//
//  PersonMovieCreditsModel.swift
//  Movieverse
//
//  Created by Mert Gökduman on 18.06.2022.
//

import Foundation

struct PersonMovieCredits: Codable {
    
    var id: Int?
    var cast: [PersonCast]?
    var success: Bool?
    var statusCode: Int?
    var statusMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case id, cast, success
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

struct PersonCast: Codable {
    
    var backdropPath: String?
    var id: Int?
    var overview, posterPath, title, character: String?
    
    enum CodingKeys: String, CodingKey {
        case id, overview, title, character
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
    }
}
