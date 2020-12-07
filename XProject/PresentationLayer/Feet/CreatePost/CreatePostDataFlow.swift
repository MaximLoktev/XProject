//
//  CreatePostDataFlow.swift
//  XProject
//
//  Created by Максим Локтев on 25.10.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

internal enum CreatePostDataFlow {
    
    enum State {
        case fill
        case active
        case empty
    }
    
    struct Item {
        let image: UIImage
        let state: State
    }
    
    enum TypeError {
        case title
        case date
        case gender
    }
    
    enum Load {

        struct Request { }

        struct Response {
            let images: [UIImage]
        }

        struct ViewModel {
            let items: [Item]
        }
        
    }
    
    enum AddPostImage {
        
        struct Request {
            let image: UIImage
        }
        
        struct Response {
            let images: [UIImage]
        }

        struct ViewModel {
            let items: [Item]
        }
    }
    
    enum DeletePostImage {
        
        struct Request {
            let image: UIImage
        }
        
        struct Response {
            let images: [UIImage]
        }

        struct ViewModel {
            let items: [Item]
        }
    }
    
    enum ChangeTitlePost {
        
        struct Request {
            let text: String
        }
        
        struct Response {
            let isWarningShow: Bool
            let isValidData: Bool
        }
        
        struct ViewModel {
            let isWarningShow: Bool
            let isValidData: Bool
            let typeError: TypeError
        }
    }
    
    enum ChangeDatePost {
        
        struct Request {
            let text: String
            let eventDate: Int
            let createDate: Int
        }
        
        struct Response {
            let isWarningShow: Bool
            let isValidData: Bool
        }
        
        struct ViewModel {
            let isWarningShow: Bool
            let isValidData: Bool
            let typeError: TypeError
        }
    }
    
    enum ChangeGenderPost {
        
        struct Request {
            let gender: Gender
        }
        
        struct Response {
            let isWarningShow: Bool
            let isValidData: Bool
        }
        
        struct ViewModel {
            let isWarningShow: Bool
            let isValidData: Bool
            let typeError: TypeError
        }
    }
    
    enum ChangeDescriptionPost {
        
        struct Request {
            let text: String
        }
        
        struct Response { }
        
        struct ViewModel { }
    }
    
    enum CreatePost {
        
        struct Request { }
        
        struct Response {
            let result: Result<Void, APIError>
        }
        
        enum ViewModel {
            case success
            case failure(title: String, description: String)
        }
    }
}
