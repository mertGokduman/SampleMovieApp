//
//  Enums.swift
//  Movieverse
//
//  Created by Mert Gökduman on 18.06.2022.
//

import Foundation

enum URLType {
    case popularMovies
    case movieDetail
    case search
    case movieCredits
    case personDetail
    case personMovieCredits
    case trailer
}

enum ServiceErrors: CustomStringConvertible {
    case internetError
    case urlError
    case apiError
    case defaultError
    
    var description : String {
        switch self {
        case .internetError:
            return "Internet connection error. Check connection and try again"
        case .urlError:
            return "Url creation error. Contact with developer"
        case .apiError:
            return "Service error. Contact with developer"
        case .defaultError:
            return "An error occured. Please try again later"
        }
    }
}
