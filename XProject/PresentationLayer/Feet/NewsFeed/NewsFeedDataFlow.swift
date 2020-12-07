//
//  NewsFeedDataFlow.swift
//  XProject
//
//  Created by Максим Локтев on 27.09.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import Foundation

internal enum NewsFeedDataFlow {
    
    enum Load {
        
        struct Request { }
        
        struct Response {
            let result: Result<[PostModel], APIError>
        }
        
        enum ViewModel {
            case success(postModel: [PostModel], isPlaceholderShow: Bool)
            case failure(title: String, description: String)
        }
    }
    
    enum Refresh {
        
        struct Request {
            let title: String
        }
        
        struct Response {
            let result: Result<[PostModel], APIError>
        }
        
        enum ViewModel {
            case success(postModel: [PostModel], isPlaceholderShow: Bool)
            case failure(title: String, description: String)
        }
    }
}
