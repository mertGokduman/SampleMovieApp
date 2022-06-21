//
//  BaseVC.swift
//  Movieverse
//
//  Created by Mert Gökduman on 18.06.2022.
//

import UIKit
import ReactiveKit
import IQKeyboardManagerSwift

class BaseVC<VM>: UIViewController where VM: BaseViewModel {
    
    lazy var viewModel: VM = VM()
    var activeDisposeBag = DisposeBag()
    
    private var gradientView: UIView = {
        let view = UIView()
        view.frame = UIScreen.main.bounds
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gradientBackground()
        bind()
        observeViewStateChanges()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        activeDisposeBag.dispose()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.shared.resignFirstResponder()
    }
    
    func bind() {}
    
    private func observeViewStateChanges() {
        
        viewModel.state.observeNext { [weak self] state in
            guard let self = self else { return}
            self.onStateChanged(state)
        }.dispose(in: bag)
    }
    
    func onStateChanged(_ state: ViewState) { }
    
    // Loading Animation Start
    func startLoading() {
        ScreenActivityIndicator.shared.startAnimation()
    }

    // Loading Animation Stop
    func stopLoading() {
        ScreenActivityIndicator.shared.stopAnimation()
    }
    
    //Background Gradient Color Method of All UIViewControllers
    private func gradientBackground() {
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = self.gradientView.frame.size
        gradientLayer.colors = [
            UIColor.customBackgroundColor1.cgColor,
            UIColor.customBackgroundColor2.cgColor
        ]
        gradientView.layer.addSublayer(gradientLayer)
        self.view.addSubview(gradientView)
        self.view.sendSubviewToBack(gradientView)
    }
}
