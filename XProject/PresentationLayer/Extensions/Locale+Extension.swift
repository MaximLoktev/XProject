//
//  Locale+Extension.swift
//  XProject
//
//  Created by Максим Локтев on 21.10.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import Foundation

extension Locale {
    
    static var firstPreferredLocale: Locale {
        let languageId = Locale.preferredLanguages.first ?? ""
        return Locale(identifier: languageId)
    }
}
