//
//  String + Extensions.swift
//  XProject
//
//  Created by Максим Локтев on 16.10.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

extension StringProtocol {
    
    var firstUppercased: String {
        prefix(1).uppercased() + dropFirst()
    }
    
    var firstCapitalized: String {
        String(prefix(1)).capitalized + dropFirst()
    }
}

extension String {
    
    func height(width: CGFloat, font: UIFont) -> CGFloat {
        
        let textSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        
        let size = self.boundingRect(with: textSize,
                                     options: .usesLineFragmentOrigin,
                                     attributes: [NSAttributedString.Key.font: font],
                                     context: nil)
        
        return ceil(size.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [NSAttributedString.Key.font: font],
                                            context: nil)
        
        return ceil(boundingBox.width)
    }
}
