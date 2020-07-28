//
//  User.swift
//  XProject
//
//  Created by Максим Локтев on 25.06.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

enum Gender: Int, Codable, CaseIterable {
    case defaults
    case android
    case ios
    case php
    
    var description: String {
        switch self {
        case .defaults:
            return "None"
        case .android:
            return "Android"
        case .ios:
            return "iOS"
        case .php:
            return "PHP"
        }
    }
}

struct UserModel: Codable {
    var name: String
    var gender: Gender
    let imageName: String = "userImageKey.png"
    
    func convertToDictionary(imageUrl: String) -> Any {
        ["name": name, "gender": gender.description, "imageURL": imageUrl]
    }
}

struct ProfilleModel {
    let name: String
    let gender: Gender
    let imageURL: String
}
