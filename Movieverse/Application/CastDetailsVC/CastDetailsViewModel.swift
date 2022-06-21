//
//  CastDetailsViewModel.swift
//  Movieverse
//
//  Created by Mert Gökduman on 18.06.2022.
//

import Foundation
import Bond
import Kingfisher

enum CastDetailsViewState: ViewState {
    case personDetail
    case movieCast
    case openWebView(String)
    case openMovieDetail(Int)
    case dismissPage
}

class CastDetailsViewModel: BaseViewModel {
    
    var personID = Observable<Int?>(nil)
    var personDetails = Observable<PersonDetailModel?>(nil)
    var movieCast = MutableObservableArray<PersonCast>()
    var selectedIndex = Observable<Int?>(nil)
    
    override init(api: AppAPI) {
        super.init(api: api)
        initErrorHandler()
    }
    
    required convenience init() {
        self.init(api: AppAPI())
    }
    
    func pageOpened() {
        getPerson()
    }
    
    private func getPerson() {
        
        guard let personID = personID.value else { return }
        api?.getPersonDetail(personID: personID,
                             succeed: parsePerson,
                             failed: handleFailure)
    }
    
    private func parsePerson(_ response: PersonDetailModel) {
        
        if response.statusMessage == nil {
            personDetails.value = response
            state.send(CastDetailsViewState.personDetail)
            if personDetails.value != nil {
               getPersonCredits()
            }
        } else {
            guard let message = response.statusMessage,
                  let statusCode = response.statusCode else { return }
            alert.send(createAlert(message,
                                   statusCode))
        }
    }
    
    private func getPersonCredits() {

        guard let personID = personID.value else { return }
        api?.getPersonCredits(personID: personID,
                              succeed: parsePersonCredits,
                              failed: handleFailure)
    }
    
    private func parsePersonCredits(_ response: PersonMovieCredits) {

        if response.statusMessage == nil {
            let castArray: [PersonCast] = response.cast~
            movieCast.replace(with: castArray)
            state.send(CastDetailsViewState.movieCast)
        } else {
            guard let message = response.statusMessage,
                  let statusCode = response.statusCode else { return }
            alert.send(createAlert(message,
                                   statusCode))
        }
    }
    
    func getImages(to imageView: UIImageView) {
        guard let urlParh = personDetails.value?.profilePath else { return }
        
        let baseURL: String = "https://image.tmdb.org/t/p/w500"
        let imageUrl = URL(string: baseURL + urlParh)
        imageView.kf.setImage(with: imageUrl)
    }
    
    func btnIMDBPressed() {
        var urlString: String = ""
        if let imdbKey = personDetails.value?.imdbID {
            let baseURL: String = "https://www.imdb.com/name/"
            urlString = baseURL + imdbKey
        } else {
            urlString = "https://www.imdb.com/"
        }
        state.send(CastDetailsViewState.openWebView(urlString))
    }
    
    func btnWebPressed()  {
        guard let urlString = personDetails.value?.homepage else { return }
        state.send(CastDetailsViewState.openWebView(urlString))
    }
    
    func btnClosePressed() {
        state.send(CastDetailsViewState.dismissPage)
    }
    
    func collectionViewCellPressed(index: Int) {
        if let id = movieCast[index].id {
            state.send(CastDetailsViewState.openMovieDetail(id))
        }
    }
    
    func initErrorHandler() {
        errorHandler = { _ in
            self.pageOpened()
        }
    }
}
