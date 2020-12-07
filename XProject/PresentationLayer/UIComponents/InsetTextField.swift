//
//  InsetTextField.swift
//  XProject
//
//  Created by Максим Локтев on 10.04.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

class InsetTextField: UITextField {
    
    // MARK: - Properties
    
    var contentInset: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: - Actions
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let bounds = bounds.inset(by: contentInset)
        return bounds
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let bounds = bounds.inset(by: contentInset)
        return bounds
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let bounds = bounds.inset(by: contentInset)
        return bounds
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentInset))
    }
}
