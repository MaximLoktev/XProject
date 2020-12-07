//
//  EditProfileDataFlow.swift
//  XProject
//
//  Created by Максим Локтев on 09.10.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

internal enum EditProfileDataFlow {
    
    enum TypeError {
        case name
        case gender
        case image
    }
    
    enum State {
        case fill
        case active
    }
    
    enum Load {

        struct Request { }

        struct Response {
            let profileModel: ProfileModel
        }

        struct ViewModel {
            let profileModel: ProfileModel
            let gender: Gender
        }
        
    }
    
    enum ChangeNameProfile {
        
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
    
    enum ChangeEmailProfile {
        
        struct Request {
            let text: String
        }
        
        struct Response { }
        
        struct ViewModel { }
    }
    
    enum ChangeBirthdayProfile {
        
        struct Request {
            let birthday: Int
        }
        
        struct Response { }
        
        struct ViewModel { }
    }
    
    enum ChangeGenderProfile {
        
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
    
    enum EditProfileImage {
        
        struct Request {
            let image: UIImage
        }
        
        struct Response {
            let image: UIImage
            let isWarningShow: Bool
            let isValidData: Bool
        }

        struct ViewModel {
            let image: UIImage
            let isWarningShow: Bool
            let isValidData: Bool
            let typeError: TypeError
            let state: State
        }
    }
    
    enum DeleteProfileImage {
        
        struct Request {
            let image: UIImage
        }
        
        struct Response {
            let image: UIImage
            let isWarningShow: Bool
            let isValidData: Bool
        }

        struct ViewModel {
            let image: UIImage
            let isWarningShow: Bool
            let isValidData: Bool
            let typeError: TypeError
            let state: State
        }
    }
    
    enum SaveProfile {
        
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
