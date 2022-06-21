//
//  UIViewController + Extension.swift
//  Movieverse
//
//  Created by Mert Gökduman on 20.06.2022.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(alert: UIAlertController) {
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    func createBlurView(for view: UIView) {
        guard !UIAccessibility.isReduceTransparencyEnabled else { return }
        view.backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.backgroundColor = UIColor.red.withAlphaComponent(0.2)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.layer.cornerRadius = 50
        blurView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        blurView.layer.masksToBounds = true
        view.insertSubview(blurView, at: 0)

        NSLayoutConstraint.activate([
          blurView.topAnchor.constraint(equalTo: view.topAnchor),
          blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
          blurView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        vibrancyView.layer.cornerRadius = 50
        vibrancyView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
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
}
