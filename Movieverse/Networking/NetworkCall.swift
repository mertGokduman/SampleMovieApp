//
//  NetworkCall.swift
//  Movieverse
//
//  Created by Mert Gökduman on 18.06.2022.
//

import Foundation
import Alamofire

class NetworkCall {
    
    static let shared = NetworkCall()
    
    let baseURL: String = "https://api.themoviedb.org/3/"
    let APIKey: String = "e3dd57661eaddf9209001d016a63ed90"
    
    // Internet Connection Control Method
    private func networkIsReachable() ->  Bool {
        let networkManager = NetworkReachabilityManager()
        let result = networkManager?.isReachable
        return result~
    }
    
    // Creating URL
    private func getURLPath(urlType: URLType, movieID: Int?, personID: Int?, page: Int?, searchText: String?) -> URL? {
        switch urlType {
        case .popularMovies:
            return URL(string: baseURL + "movie/popular" + "?api_key=\(APIKey)" + "&page=\(page ?? 1)")
        case .movieDetail:
            return URL(string: baseURL + "movie/" + "\(movieID~)" + "?api_key=\(APIKey)")
        case .search:
            return URL(string: baseURL + "search/multi" + "?api_key=\(APIKey)" + "&query=\(searchText~)" + "&page=\(page ?? 1)")
        case .movieCredits:
            return URL(string: baseURL + "movie/\(movieID~)/credits" + "?api_key=\(APIKey)")
        case .personDetail:
            return URL(string: baseURL + "person/" + "\(personID~)" + "?api_key=\(APIKey)")
        case .personMovieCredits:
            return URL(string: baseURL + "person/\(personID~)/movie_credits" + "?api_key=\(APIKey)")
        case .trailer:
            return URL(string: baseURL + "movie/\(movieID~)/videos" + "?api_key=\(APIKey)")
        }
    }
    
    // Service Request
    func request<S: Codable>(methodType: HTTPMethod,
                             urlType: URLType,
                             movieID: Int? = nil,
                             personID: Int? = nil,
                             page: Int? = 1,
                             searchText: String? = "",
                             succeed: @escaping (S) -> Void,
                             failed: @escaping (ServiceErrors) -> Void) {
          
          if networkIsReachable() {
              guard let url = getURLPath(urlType: urlType,
                                         movieID: movieID,
                                         personID: personID,
                                         page: page,
                                         searchText: searchText) else {
                  failed(.urlError)
                  return
              }
              
              AF.request(url, method: methodType).responseDecodable(of: S.self) { response in
                  if let error = response.error {
                      print("There is an error when fetching data" + "\(error)")
                      failed(.defaultError)
                  } else {
                      if let value = response.value {
                          succeed(value)
                      } else {
                          failed(.apiError)
                      }
                  }
              }
          } else {
              failed(.internetError)
              return
          }
      }
}
