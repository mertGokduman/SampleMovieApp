//
//  UITextField + Extension.swift
//  Movieverse
//
//  Created by Mert Gökduman on 20.06.2022.
//

import Foundation
import UIKit

extension UITextField {
    
    func setSearchBar() {

        self.layer.borderColor =  UIColor.white.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 10
        self.attributedPlaceholder = NSAttributedString( string: "Search Movie, Person etc.",
                                                         attributes: [
                                                            NSAttributedString.Key.foregroundColor: UIColor.white,
                                                            NSAttributedString.Key.font: UIFont(name: "Nunito-SemiBold", size: 16)!
                                                         ]
        )
        setLeftView()
        setRightView()
    }

    func setLeftView() {

        let searchView: UIView = {
            let tempView = UIView()
            let tempImageView = UIImageView(image: UIImage(named: "search")?.withRenderingMode(.alwaysTemplate))
            tempImageView.tintColor = .white
            tempImageView.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
            tempView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            tempView.addSubview(tempImageView)
            return tempView
        }()
        self.leftView = searchView
        self.leftViewMode = .always
    }

    func setRightView() {
        self.clearButtonMode = .whileEditing
    }
}
