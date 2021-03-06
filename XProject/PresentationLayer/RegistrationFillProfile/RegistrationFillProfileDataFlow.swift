//
//  RegistrationFillProfileDataFlow.swift
//  XProject
//
//  Created by Максим Локтев on 18.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

internal enum RegistrationFillProfileDataFlow {
    
    enum Content {
        case name(String)
        case gender(Gender)
        case image(UIImage?)
    }
    
    struct Profile {
        var name: String
        var gender: Gender
        var image: UIImage?
    }
    
    struct Item {
        let title: String
        let content: Content
        let buttonTitle: String
    }
    
    struct PageContent {
        let items: [Item]
        let page: Int
        let isLastPage: Bool
        let isNameFilled: Bool
        let buttonTitle: String
    }
    
    enum Load {

        struct Request { }

        struct Response {
            let profile: Profile
        }

        struct ViewModel {
            let items: [Item]
        }
        
    }
    
    enum ScrollTableViewIfNeeded {
        
        struct Request { }

        struct Response {
            let profile: Profile
            let index: Int
        }

        struct ViewModel {
            let buttonTitle: String
            let index: Int
        }
    }
    
    enum NextPage {
        
        struct Request {
            let content: Content
        }
        
        enum Response {
            case success(profile: Profile, page: Int)
            case failure(error: APIError)
        }
        
        enum ViewModel {
            case success(content: PageContent)
            case failure(title: String, description: String)
        }
    }
    
    enum CreateNamedImage {
        
        struct Request { }

        struct Response {
            let result: Result<Profile, APIError>
        }
        
        enum ViewModel {
            case success
            case failure(title: String, description: String)
        }
    }
    
    enum SelectPage {
        
        struct Request {
            let page: Int
        }
        
        struct Response {
            let page: Int
            let profile: Profile
        }
        
        struct ViewModel {
            let page: Int
            let buttonTitle: String
        }
    }
    
    enum AddUserImage {
        
        struct Request {
            let image: UIImage
        }
        
        struct Response {
            let result: Result<Profile, APIError>
        }
        
        enum ViewModel {
            case success(items: [Item])
            case failure(title: String, description: String)
        }
    }
    
    enum SaveUserInFirebase {
        
        struct Request { }
        
        struct Response {
            let result: Result<ProfileModel, APIError>
        }
        
        enum ViewModel {
            case success
            case failure(title: String, description: String)
        }
    }
    
    enum EnterUserName {
        
        struct Request {
            let text: String
        }
        
        struct Response {
            let isWarningShow: Bool
        }
        
        struct ViewModel {
            let isWarningShow: Bool
            let textError: String
        }
    }
    
    enum GenderDidSelected {
        
        struct Request {
            let gender: Gender
        }
        
        struct Response {
            let isWarningShow: Bool
        }
        
        struct ViewModel {
            let isWarningShow: Bool
            let textError: String
        }
    }
}
