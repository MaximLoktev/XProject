//
//  CALayer+Extensions.swift
//  XProject
//
//  Created by Максим Локтев on 04.04.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

extension CALayer {
    func applySketchShadow(color: UIColor = .black,
                           alpha: Float = 0.2,
                           x: CGFloat = 0,
                           y: CGFloat = 0,
                           blur: CGFloat = 6,
                           spread: CGFloat = 0) {
        
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
