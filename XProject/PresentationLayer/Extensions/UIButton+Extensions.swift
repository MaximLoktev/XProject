//
//  UIButton+Extensions.swift
//  XProject
//
//  Created by Максим Локтев on 09.04.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

extension UIButton {
    
    static func shadowButton() -> UIButton {
        let button = UIButton()
        button.layer.applySketchShadow(color: .sexyBlack,
                                       alpha: 0.2,
                                       x: 0.0,
                                       y: 4.0,
                                       blur: 6.0,
                                       spread: 0.0)
        
        button.backgroundColor = .twilightBlue
        button.layer.cornerRadius = 12.0
        
        return button
    }
}
