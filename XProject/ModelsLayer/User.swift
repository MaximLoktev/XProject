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
    var imageName: String = "userImageKey.png"
    var email: String?
    var birthday: Int?
    
    func convertToDictionary(imageUrl: String, token: String) -> [String: Any] {
        ["name": name, "birthday": birthday ?? 0, "gender": gender.description,
         "imageURL": imageUrl, "email": email ?? "", "userId": token
        ]
    }
}

struct ProfileModel: Codable {
    var name: String
    var birthday: Int?
    var gender: String
    var imageURL: String
    var email: String?
    var userId: String
}
