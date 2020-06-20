//
//  InsetTextField.swift
//  XProject
//
//  Created by Максим Локтев on 10.04.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

class InsetTextField: UITextField, UITextFieldDelegate {
    
    var contentInset: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 12.0, bottom: 0.0, right: 16.0) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let allowedCharacters =
        """
            ABCDEFGHIJKLMNOPQRSTUVWXYZ
            abcdefghijklmnopqrstuvwxyz0123456789
            йцукенгшщзхъёэждлорпавыфячсмитьбю
            ЙЦУКЕНГШЩЗХЪЁЭЖДЛОРПАВЫФЯЧСМИТЬБЮ
        """
        
        let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
        let typedCharacterSet = CharacterSet(charactersIn: string)
        
        guard
            let text = textField.text
            else {
                return true
        }
        
        let newLength = text.count + string.count - range.length
        
        return allowedCharacterSet.isSuperset(of: typedCharacterSet) && newLength <= 25
    }
}
