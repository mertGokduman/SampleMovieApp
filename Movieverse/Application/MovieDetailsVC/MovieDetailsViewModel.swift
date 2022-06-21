//
//  MovieDetailsViewModel.swift
//  Movieverse
//
//  Created by Mert Gökduman on 18.06.2022.
//

import Foundation
import Bond
import Kingfisher

enum MovieDetailsViewState: ViewState {
    case movieDetailsCame
    case castDataCame
    case openWebView(String)
    case openCastDetail(Int)
    case dismissPage
}

class MovieDetailsViewModel: BaseViewModel {
    
    var movieID = Observable<Int?>(nil)
    var movieDetails = Observable<DetailsTVModel?>(nil)
    var movieCast = MutableObservableArray<MovieCast>()
    var movieVideoKey = Observable<VideoResult?>(nil)
    var selectedIndex = Observable<Int?>(nil)
    
    override init(api: AppAPI) {
        super.init(api: api)
        initErrorHandler()
    }
    
    required convenience init() {
        self.init(api: AppAPI())
    }
    
    func pageOpened() {
        getMovieDetail()
    }
    
    private func getMovieDetail() {
        
        guard let movieID = movieID.value else { return }
        api?.getMovieDetail(movieID: movieID,
                            succeed: parseDetailDate,
                            failed: handleFailure)
    }
    
    private func parseDetailDate(_ response: DetailsTVModel) {
        
        if response.statusMessage == nil {
            movieDetails.value = response
            state.send(MovieDetailsViewState.movieDetailsCame)
            if movieDetails.value != nil {
                getTrailers()
                getCasts()
            }
        } else {
            guard let message = response.statusMessage,
                  let statusCode = response.statusCode else { return }
            alert.send(createAlert(message,
                                   statusCode))
        }
    }
    
    private func getTrailers() {
        
        guard let movieID = movieID.value else { return }
        api?.getMovieTrailer(movieID: movieID,
                             succeed: parseTrailers,
                             failed: handleFailure)
    }
    
    private func parseTrailers(_ response: VideoModel) {
        
        if response.results != nil && response.results?.count != 0 && response.statusMessage == nil {
            let index = response.results?.firstIndex { $0.type == "Trailer" }
            movieVideoKey.value = response.results?[index~]
        }
    }
    
    private func getCasts() {
        
        guard let movieID = movieID.value else { return }
        api?.getMovieCredits(movieID: movieID,
                             succeed: parseCasts,
                             failed: handleFailure)
    }
    
    private func parseCasts(_ response: MovieCreditsModel) {
        
        if response.statusMessage == nil {
            let castArray: [MovieCast] = response.cast~
            movieCast.replace(with: castArray)
            state.send(MovieDetailsViewState.castDataCame)
        } else {
            guard let message = response.statusMessage,
                  let statusCode = response.statusCode else { return }
            alert.send(createAlert(message,
                                   statusCode))
        }
    }
    
    func getImages(to imageView: UIImageView) {
        guard let movie = movieDetails.value else { return }
        let urlPath = movie.backdropPath != nil ? movie.backdropPath : movie.posterPath
        let baseURL: String = "https://image.tmdb.org/t/p/w500"
        let imageUrl = URL(string: baseURL + urlPath~)
        imageView.kf.setImage(with: imageUrl)
    }
    
    func btnPlayPressed() {
        var urlString: String = ""
        if let videoKey = movieVideoKey.value?.key {
            let baseURL: String = "https://www.youtube.com/watch?v="
            urlString = baseURL + videoKey
        } else {
            urlString = "https://www.youtube.com/"
        }
        state.send(MovieDetailsViewState.openWebView(urlString))
    }
    
    func btnIMDBPressed() {
        var urlString: String = ""
        if let imdbKey = movieDetails.value?.imdbID {
            let baseURL: String = "https://www.imdb.com/title/"
            urlString = baseURL + imdbKey
        } else {
            urlString = "https://www.imdb.com/"
        }
        state.send(MovieDetailsViewState.openWebView(urlString))
    }
    
    func btnWebPressed()  {
        guard let urlString = movieDetails.value?.homepage else { return }
        state.send(MovieDetailsViewState.openWebView(urlString))
    }
    
    func btnClosePressed() {
        state.send(MovieDetailsViewState.dismissPage)
    }
    
    func getGenreString() -> String {
        if let genre = movieDetails.value?.genres, !genre.isEmpty {
            var string = ""
            for item in genre {
                string += " " + item.name~ + ","
            }
            string.removeFirst()
            string.removeLast()
            return string
        }
        return ""
    }
    
    func getRuntime() -> String {
        guard let runtime = movieDetails.value?.runtime else { return ""}
        let hour = runtime / 60
        let minutes = runtime % 60
        let strRuntime = "\(hour)h \(minutes)min"
        return strRuntime
    }
    
    func collectionViewCellPressed(index: Int) {
        if let id = movieCast[index].id {
            state.send(MovieDetailsViewState.openCastDetail(id))
        }
    }
    
    func initErrorHandler() {
        errorHandler = { _ in
            self.pageOpened()
        }
    }
}
