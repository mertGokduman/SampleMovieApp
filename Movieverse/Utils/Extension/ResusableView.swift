//
//  ResusableView.swift
//  Movieverse
//
//  Created by Mert Gökduman on 20.06.2022.
//

import Foundation
import UIKit

protocol ReusableView: AnyObject {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView {}

extension UICollectionReusableView: ReusableView {}
