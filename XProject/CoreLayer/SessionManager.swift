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
    func haveSession() -> Bool
}

final class InMemorySessionStorage: SessionManager {
    
    private var accessToken: String?
    
    private let keychain: Keychain
    
    private let accessTokenIdentifier: String = "SBAccessToken"
    
    init() {
        keychain = Keychain(accessGroup: "EV4MFSH375.com.MaxLoktev.XProject")
        accessToken = self.keychain[self.accessTokenIdentifier]
    }
    
    func storeToken(accessToken: String) {
        self.accessToken = accessToken
        keychain[self.accessTokenIdentifier] = accessToken
    }
    
    func getAccessToken() -> String? {
        accessToken
    }
    
    func haveSession() -> Bool {
        accessToken != nil
    }

}
