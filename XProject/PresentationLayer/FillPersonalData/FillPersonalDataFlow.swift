//
//  FillPersonalDataFlow.swift
//  XProject
//
//  Created by Максим Локтев on 01.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

enum FillPersonalDataFlow {
    
    enum Content {
        case name(String)
        case gender(Gender)
        case image(String, UIImage?)
    }
    
    struct PersonalData {
        let title: String
        let content: Content
        let buttonTitle: String
    }
    
    struct SetupNewPage {
        let index: Int
        let isLast: Bool
        let item: PersonalData
    }
}
