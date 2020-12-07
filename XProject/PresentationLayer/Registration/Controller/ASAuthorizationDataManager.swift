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
    
    // MARK: - Properties
    
    var onUserAuthorization: ((Result<UserModel, APIError>) -> Void)?
    var onAuthorizationError: ((Error) -> Void)?
    
    private let sessionManager: SessionManager
    private let fileDataStorageService: FileDataStorageService
    
    // MARK: - Init
    
    init(sessionManager: SessionManager, fileDataStorageService: FileDataStorageService) {
        self.sessionManager = sessionManager
        self.fileDataStorageService = fileDataStorageService
    }
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        guard
            let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let tokenData = credential.authorizationCode,
            let token = String(data: tokenData, encoding: .utf8)
        else { return }

        let firstName = credential.fullName?.givenName ?? ""
        let lastName = credential.fullName?.familyName ?? ""
        let email = credential.email
        
        sessionManager.storeToken(accessToken: token)
        let userModel = UserModel(name: firstName + lastName, gender: .defaults, email: email)
        fileDataStorageService.writingData(user: userModel) { [weak self] result in
            self?.onUserAuthorization?(result)
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        onAuthorizationError?(error)
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let present = UIApplication.shared.windows.first ?? UIWindow()
        return present
    }
}
