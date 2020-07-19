//
//  ASAuthorizationDataManager.swift
//  XProject
//
//  Created by Максим Локтев on 04.04.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import AuthenticationServices
import UIKit

class ASAuthorizationDataManager: NSObject,
    ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    
    var sessionManager: SessionManager
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        sessionManager.storeToken(accessToken: "еуые")
    }
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
//            let fullName = appleIDCredential.fullName
//            let email = appleIDCredential.email
//            
//            print(userIdentifier, fullName!, email!)
            
            sessionManager.storeToken(accessToken: userIdentifier)
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //print("Error")
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let present = UIApplication.shared.windows.first ?? UIWindow()
        return present
    }
}
