//
//  NewFeed.swift
//  XProject
//
//  Created by Максим Локтев on 11.10.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

struct PostModel: Decodable, Encodable {
    var image: [String]?
    var title: String = ""
    var date: Int = 0
    var gender: String = ""
    var description: String?
    var icon: String = ""
    var creatorName: String = ""
    var createDate: Int = 0
    var creatorId: String = ""
    var id: String = ""
    
//    func convertToDictionary() -> NSDictionary {
//        ["image": image ?? [""],
//         "title": title,
//         "date": date,
//         "gender": gender,
//         "description": description ?? "",
//         "icon": icon,
//         "creatorName": creatorName,
//         "createDate": createDate,
//         "creatorId": creatorId]
//    }
}

enum PostsFilter {
    case gender
    case creatorId
    
    var description: String {
        switch self {
        case .gender:
            return "gender"
        case .creatorId:
            return "creatorId"
        }
    }
}
