//
//  SessionManager.swift
//  XProject
//
//  Created by Максим Локтев on 03.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import KeychainAccess

protocol SessionManager {
    func storeToken(accessToken: String)
    func getAccessToken() -> String?
    func getPostId() -> String
    func getUserId() -> String
    func haveSession() -> Bool
}

final class InMemorySessionStorage: SessionManager {
    
    private var accessToken: String?
    
    private let keychain: Keychain
    
    private let userId: String = UUID().uuidString
    
    private let postId: String = UUID().uuidString
    
    private let accessTokenIdentifier: String = "SBAccessToken"
    
    init() {
        keychain = Keychain(accessGroup: "EV4MFSH375.com.MaxLoktev.XProject")
        try? keychain.remove(self.accessTokenIdentifier)
        accessToken = self.keychain[self.accessTokenIdentifier]
    }
    
    func storeToken(accessToken: String) {
        self.accessToken = accessToken
        keychain[self.accessTokenIdentifier] = accessToken
    }
    
    func getAccessToken() -> String? {
        accessToken
    }
    
    func getUserId() -> String {
        userId
    }
    
    func getPostId() -> String {
        postId
    }
    
    func haveSession() -> Bool {
        accessToken != nil
    }

}
