//
//  VideoModel.swift
//  Movieverse
//
//  Created by Mert Gökduman on 18.06.2022.
//

import Foundation

struct VideoModel: Codable {
    
    var id: Int?
    var results: [VideoResult]?
    var success: Bool?
    var statusCode: Int?
    var statusMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case id, results, success
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

struct VideoResult: Codable {
    var name, key, site, type: String?
    
    enum CodingKeys: String, CodingKey {
        case name, key, site, type
    }
}
