//
//  InsetLabel.swift
//  XProject
//
//  Created by Максим Локтев on 23.10.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

internal class InsetLabel: UILabel {
    
    var contentInset = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentInset))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + contentInset.left + contentInset.right,
                      height: size.height + contentInset.top + contentInset.bottom)
    }
}
