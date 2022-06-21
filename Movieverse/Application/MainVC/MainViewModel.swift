//
//  MainViewModel.swift
//  Movieverse
//
//  Created by Mert Gökduman on 18.06.2022.
//

import Foundation
import Bond

enum MainViewState: ViewState {
    case popularDataCame
    case searchDataCame
    case pagination
    case tableViewPressed(Int)
    case searchTablePressed(Int, String)
}

class MainViewModel: BaseViewModel {
    
    var currentPage: Int = 1
    
    var generalPopularResult: [MovieModel] = []
    var generalSearchResult: [SearchResult] = []
    var popularResults = MutableObservableArray<MovieModel>()
    var searchResults = MutableObservableArray<SearchResult>()
    
    var selectedTableIndex = Observable<Int?>(nil)
    var selectedSearchTableIndex = Observable<Int?>(nil)
    
    var isSearhing: Bool = false
    var totalSearchedResult: Int = 0

    override init(api: AppAPI) {
        super.init(api: api)
        initErrorHandler()
    }
    
    required convenience init() {
        self.init(api: AppAPI())
    }
    
    func pageOpened() {
        getMovies()
    }
    
    private func getMovies() {
        api?.getPopularMovies(page: 1,
                              succeed: parsePopularMovies,
                              failed: handleFailure)
    }
    
    private func parsePopularMovies(_ response: PopularMovieModel) {
        if response.statusMessage == nil {
            currentPage = response.getPage()
            generalPopularResult = response.getResult()
            popularResults.replace(with: generalPopularResult)
            state.send(MainViewState.popularDataCame)
        } else {
            guard let message = response.statusMessage,
                  let statusCode = response.statusCode else { return }
            alert.send(createAlert(message,
                                   statusCode)) 
        }
    }
        
    func moviesPagination() {
        currentPage += 1
        api?.getPopularMovies(page: currentPage,
                              succeed: parsePaginationData,
                              failed: handleFailure)
    }
    
    private func parsePaginationData(_ response: PopularMovieModel) {
        if !response.getResult().isEmpty {
            generalPopularResult.append(contentsOf: response.getResult())
            popularResults.replace(with: generalPopularResult)
        }
        state.send(MainViewState.pagination)
    }
    
    func getSearchedResults(searchedText: String) {
        let searchText = searchedText.replacingOccurrences(of: " ",
                                                           with: "%20")
        api?.getSearchData(page: 1,
                           searchText: searchText,
                           succeed: parseSearchData,
                           failed: handleFailure)
    }
    
    private func parseSearchData(_ response: SearchModel) {
        if response.statusMessage == nil {
            totalSearchedResult = response.totalResults~
            generalSearchResult = response.getResult()
            searchResults.replace(with: removeTvShows(data: generalSearchResult))
            state.send(MainViewState.searchDataCame)
        } else {
            guard let message = response.statusMessage,
                  let statusCode = response.statusCode else { return }
            alert.send(createAlert(message,
                                   statusCode))
        }
    }
    
    private func removeTvShows(data: [SearchResult]) -> [SearchResult] {
        let newList = data.filter { $0.mediaType != "tv"}
        return newList
    }
    
    func tableViewCellPressed(index: Int) {
        if let id = popularResults[index].id {
            state.send(MainViewState.tableViewPressed(id))
        }
    }
    
    func searchTableViewCellPressed(index: Int) {
        if let id = searchResults[index].id,
           let type = searchResults[index].mediaType {
            state.send(MainViewState.searchTablePressed(id, type))
        }
    }
    
    func initErrorHandler() {
        errorHandler = { _ in
            self.pageOpened()
        }
    }
}
