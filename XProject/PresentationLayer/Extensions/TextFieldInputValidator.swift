//
//  TextFieldInputValidator.swift
//  XProject
//
//  Created by Максим Локтев on 28.10.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import Foundation

protocol TextFieldInputValidator {
    func shouldChangeCharacters(of originalString: String,
                                in range: NSRange,
                                replacementText text: String) -> Bool
    
    func shouldChangeTextIn(of originalString: String,
                            in range: NSRange,
                            replacementText text: String) -> Bool
}

struct AlphanumericsValidator: TextFieldInputValidator {
    
    func shouldChangeCharacters(of originalString: String,
                                in range: NSRange,
                                replacementText text: String) -> Bool {
        let alphanumericsCharacterSet = CharacterSet.alphanumerics
        let whitespacesCharacterSet = CharacterSet.whitespaces
        let typedCharacterSet = CharacterSet(charactersIn: text)
        let length = originalString.count + text.count - range.length
        
        return (alphanumericsCharacterSet.isSuperset(of: typedCharacterSet)
                || whitespacesCharacterSet.isSuperset(of: typedCharacterSet)) && length <= 25
    }
    
    func shouldChangeTextIn(of originalString: String, in range: NSRange, replacementText text: String) -> Bool {
        let length = originalString.count + text.count - range.length
        
        return length <= 500
    }
}
//
//func textField(_ textField: UITextField,
//               shouldChangeCharactersIn range: NSRange,
//               replacementString string: String) -> Bool {
//
//    #warning("Zamenit na validator")
//    let currentText = textField.text ?? ""
//    guard let stringRange = Range(range, in: currentText) else {
//        return false
//    }
//
//    let updateText = currentText.replacingCharacters(in: stringRange, with: string)
//
//    if keyboardType == .numberPad {
//        return updateText.count < 4
//    }
//    return updateText.count < 32
//}
