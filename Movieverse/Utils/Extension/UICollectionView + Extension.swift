//
//  UICollectionView + Extension.swift
//  Movieverse
//
//  Created by Mert Gökduman on 20.06.2022.
//

import Foundation
import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(_ type: T.Type) {
        let name = String(describing: type).components(separatedBy: ".")[0]
        register(UINib(nibName: name, bundle: nil), forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }

    func register<T: UICollectionReusableView>(_ type: T.Type, for kind: String) {
        let name = String(describing: type).components(separatedBy: ".")[0]
        register(UINib(nibName: name, bundle: nil),
                 forSupplementaryViewOfKind: kind,
                 withReuseIdentifier: T.defaultReuseIdentifier)
    }

    func dequeueCell<T: UICollectionViewCell>(_: T.Type, forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier,
                                             for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }

        return cell
    }

    func dequeueReusableView<T: UICollectionReusableView>(_: T.Type, kind: String, indexPath: IndexPath) -> T {
        guard let reusableView = dequeueReusableSupplementaryView(ofKind: kind,
                                                                  withReuseIdentifier: T.defaultReuseIdentifier,
                                                                  for: indexPath) as? T else {
            fatalError("Could not dequeue reusable view with identifier: \(T.defaultReuseIdentifier)")
        }

        return reusableView
    }
}
