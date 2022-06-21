//
//  BaseViewModel.swift
//  Movieverse
//
//  Created by Mert Gökduman on 18.06.2022.
//

import Foundation
import ReactiveKit
import Bond
import UIKit

protocol ViewState {}

enum BaseViewState: ViewState {}

class BaseViewModel {

    var api: AppAPI?
    var bag = DisposeBag()
    var alert = PassthroughSubject<UIAlertController, Never>()
    var state = PassthroughSubject<ViewState, Never>()
    var errorHandler: ((UIAlertAction) -> Void)?
    
    init(api: AppAPI) {
        self.api = api
    }
    
    required init() {
        // Intentionally unimplemented
    }
    
    func handleFailure(_ model: ServiceErrors) {
        let mainAlert = createAlert(model.description)
        alert.send(mainAlert) 
    }
    
    func createAlert(_ message: String, _ statusCode: Int? = nil) -> UIAlertController {

        let alert = UIAlertController(title: "Error!",
                                      message: message,
                                      preferredStyle: .alert)
        let retryAlertAction = UIAlertAction(title: "Retry",
                                             style: .default,
                                             handler: errorHandler)
        
        let cancelAlertAction = UIAlertAction(title: "OK",
                                              style: .cancel)
        
        if statusCode == nil {
            alert.addAction(retryAlertAction)
        }
        alert.addAction(cancelAlertAction)
        
        return alert
    }
    
    func disposeBag() {
        bag.dispose()
    }
    
}
