//
//  DataFetch.swift
//  Movieverse
//
//  Created by Mert Gökduman on 18.06.2022.
//

import Foundation

class AppAPI {
    
    static let shared = AppAPI()
    
    func getPopularMovies(page: Int,
                          succeed: @escaping (PopularMovieModel) -> Void,
                          failed: @escaping (ServiceErrors) -> Void) {
        NetworkCall.shared.request(methodType: .get,
                                   urlType: .popularMovies,
                                   page: page,
                                   succeed: succeed,
                                   failed: failed)
    }
    
    func getMovieDetail(movieID: Int,
                        succeed: @escaping (DetailsTVModel) -> Void,
                        failed: @escaping (ServiceErrors) -> Void) {
        NetworkCall.shared.request(methodType: .get,
                                   urlType: .movieDetail,
                                   movieID: movieID,
                                   succeed: succeed,
                                   failed: failed)
    }
    
    func getMovieCredits(movieID: Int,
                         succeed: @escaping (MovieCreditsModel) -> Void,
                         failed: @escaping (ServiceErrors) -> Void) {
        NetworkCall.shared.request(methodType: .get,
                                   urlType: .movieCredits,
                                   movieID: movieID,
                                   succeed: succeed,
                                   failed: failed)
    }
    
    func getMovieTrailer(movieID: Int,
                         succeed: @escaping (VideoModel) -> Void,
                         failed: @escaping (ServiceErrors) -> Void) {
        NetworkCall.shared.request(methodType: .get,
                                   urlType: .trailer,
                                   movieID: movieID,
                                   succeed: succeed,
                                   failed: failed)
    }
    
    func getPersonDetail(personID: Int,
                         succeed: @escaping (PersonDetailModel) -> Void,
                         failed: @escaping (ServiceErrors) -> Void) {
        NetworkCall.shared.request(methodType: .get,
                                   urlType: .personDetail,
                                   personID: personID,
                                   succeed: succeed,
                                   failed: failed)
    }
    
    func getPersonCredits(personID: Int,
                          succeed: @escaping (PersonMovieCredits) -> Void,
                          failed: @escaping (ServiceErrors) -> Void) {
        NetworkCall.shared.request(methodType: .get,
                                   urlType: .personMovieCredits,
                                   personID: personID,
                                   succeed: succeed,
                                   failed: failed)
    }
    
    func getSearchData(page: Int,
                       searchText: String,
                       succeed: @escaping (SearchModel) -> Void,
                       failed: @escaping (ServiceErrors) -> Void) {
        NetworkCall.shared.request(methodType: .get,
                                   urlType: .search,
                                   page: page,
                                   searchText: searchText,
                                   succeed: succeed,
                                   failed: failed)
    }
}
