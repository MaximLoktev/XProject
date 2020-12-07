//
//  AdjustedTapAreaButton.swift
//  XProject
//
//  Created by Максим Локтев on 01.11.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

internal class AdjustedTapAreaButton: UIButton {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let widthDelta: CGFloat = 44.0 - self.bounds.size.width
        let heightDelta: CGFloat = 44.0 - self.bounds.size.height
        let widthBounds = bounds.size.width >= 44.0 ? 0.0 : -0.5 * widthDelta
        let heightBounds = bounds.size.height >= 44.0 ? 0.0 : -0.5 * heightDelta
        let largerBounds: CGRect = bounds.insetBy(dx: widthBounds, dy: heightBounds)
        return largerBounds.contains(point)
    }
}
