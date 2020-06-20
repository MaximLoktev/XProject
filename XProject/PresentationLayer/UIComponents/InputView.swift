//
//  InputView.swift
//  XProject
//
//  Created by Максим Локтев on 04.04.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

class InputView: UIView {
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .white
        layer.applySketchShadow(color: .sexyBlack,
                                alpha: 0.2,
                                x: 0.0,
                                y: 4.0,
                                blur: 8.0,
                                spread: 0.0)
        layer.masksToBounds = false
        layer.cornerRadius = 8.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
