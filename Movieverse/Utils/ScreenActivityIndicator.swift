//
//  ScreenActivityIndicator.swift
//  Movieverse
//
//  Created by Mert Gökduman on 18.06.2022.
//

import Foundation
import UIKit
import Lottie

class ScreenActivityIndicator: UIView {
    
    static let shared = ScreenActivityIndicator()
    
    private var animationView: AnimationView?
    private var isAnimate: Bool = false
    
    private override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        
        createAnimationView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createAnimationView() {
        
        animationView = AnimationView(name: "loading")
        animationView?.loopMode = .loop
        animationView?.contentMode = .scaleAspectFit
        self.addSubview(animationView!)
    }
    
    private func setAnimationFrame() {
        self.center = UIScreen.main.bounds.center
        self.frame = UIScreen.main.bounds
        animationView?.frame = CGRect(x: 0,
                                      y: 0,
                                      width: UIScreen.main.bounds.width / 2,
                                      height: UIScreen.main.bounds.width / 2)
        animationView?.center = UIScreen.main.bounds.center
    }
    
    public func startAnimation() {

        if !isAnimate {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            if var topController = appDelegate.window?.rootViewController {
                if let presentedController = topController.presentedViewController {
                    topController = presentedController
                }
                setAnimationFrame()
                createBlurBackgroundView()
                
                animationView?.play()
                topController.view.addSubview(self)
                topController.view.bringSubviewToFront(self)
            }
            isAnimate = true
        }
    }
    
    private func createBlurBackgroundView() {
        guard !UIAccessibility.isReduceTransparencyEnabled else { return }
        self.backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.backgroundColor = UIColor.red.withAlphaComponent(0.1)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(blurView, at: 0)

        NSLayoutConstraint.activate([
          blurView.topAnchor.constraint(equalTo: self.topAnchor),
          blurView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
          blurView.heightAnchor.constraint(equalTo: self.heightAnchor),
          blurView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])

        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        blurView.contentView.addSubview(vibrancyView)

        NSLayoutConstraint.activate([
          vibrancyView
            .heightAnchor
            .constraint(equalTo: blurView.contentView.heightAnchor),
          vibrancyView
            .widthAnchor
            .constraint(equalTo: blurView.contentView.widthAnchor),
          vibrancyView
            .centerXAnchor
            .constraint(equalTo: blurView.contentView.centerXAnchor),
          vibrancyView
            .centerYAnchor
            .constraint(equalTo: blurView.contentView.centerYAnchor)
        ])
    }
    
    public func stopAnimation() {
        animationView?.stop()
        isAnimate = false
        self.removeFromSuperview()
    }
}
