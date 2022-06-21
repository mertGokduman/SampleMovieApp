//
//  UITableView + Extension.swift
//  Movieverse
//
//  Created by Mert Gökduman on 20.06.2022.
//

import Foundation
import UIKit

// For register and create cell 
extension UITableView {
    
    func register<T: UITableViewCell>(_ type: T.Type) {
        let name = String(describing: type).components(separatedBy: ".")[0]
        register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: T.defaultReuseIdentifier)
    }

    func dequeueCell<T: UITableViewCell>(_: T.Type, forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier,
                                             for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }

        return cell
    }
}


