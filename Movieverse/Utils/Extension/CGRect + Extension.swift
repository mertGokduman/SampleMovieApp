//
//  CGRect + Extension.swift
//  Movieverse
//
//  Created by Mert Gökduman on 18.06.2022.
//

import Foundation
import UIKit

extension CGRect {
    var center: CGPoint { .init(x: midX, y: midY) }
}
