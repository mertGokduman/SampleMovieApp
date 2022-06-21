//
//  PersonDetailModel.swift
//  Movieverse
//
//  Created by Mert Gökduman on 18.06.2022.
//

import Foundation

struct PersonDetailModel: Codable {
    
    var biography, birthday, deathday, homepage, imdbID, name, profilePath, placeOfBirth: String?
    var id: Int?
    var success: Bool?
    var statusCode: Int?
    var statusMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case biography, birthday, deathday, homepage, name, id, success
        case imdbID = "imdb_id"
        case placeOfBirth = "place_of_birth"
        case profilePath = "profile_path"
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}
