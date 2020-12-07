//
//  HighlightedButton.swift
//  XProject
//
//  Created by Максим Локтев on 07.11.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

internal class HighlightedButton: UIButton {
    
    // MARK: - Properties
    
    var normalBackgroundcolor: UIColor = UIColor.white {
        didSet {
            backgroundColor = normalBackgroundcolor
        }
    }
    
    var highlightedBackgroundcolor: UIColor = UIColor.white
    
    var normalTextColor: UIColor = UIColor.white {
        didSet {
            setTitleColor(normalTextColor, for: .normal)
        }
    }
    
    var highlightedTextcolor: UIColor = UIColor.white {
        didSet {
            setTitleColor(highlightedTextcolor, for: .highlighted)
        }
    }
    
    var disabledBackgroundColor: UIColor = UIColor.white
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        self.isHighlighted = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal override var isHighlighted: Bool {
        didSet {
            setColor()
        }
    }
    
    internal override var isEnabled: Bool {
        didSet {
            setColor()
            let color = isEnabled ? normalTextColor : highlightedTextcolor
            setTitleColor(color, for: .normal)
        }
    }
    
    private func setColor() {
        if !isEnabled {
            backgroundColor = disabledBackgroundColor
        } else {
            backgroundColor = isHighlighted ? highlightedBackgroundcolor : normalBackgroundcolor
        }
    }
}
