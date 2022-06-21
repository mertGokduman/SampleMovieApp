//
//  MovieCreditsModel.swift
//  Movieverse
//
//  Created by Mert Gökduman on 18.06.2022.
//

import Foundation

struct MovieCreditsModel:Codable {
    
    var id: Int?
    var cast: [MovieCast]?
    var success: Bool?
    var statusCode: Int?
    var statusMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case id, cast, success
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

struct MovieCast: Codable {
    
    var id: Int?
    var name, profilePath, character: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, character
        case profilePath = "profile_path"
    }
}
