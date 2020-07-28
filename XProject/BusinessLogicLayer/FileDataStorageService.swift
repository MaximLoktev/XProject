//
//  FileDataStorageService.swift
//  XProject
//
//  Created by Максим Локтев on 04.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

protocol FileDataStorageService {
    func writingData(user: UserModel, completion: @escaping (Result<UserModel, APIError>) -> Void)
    func readingData(completion: @escaping (Result<UserModel, APIError>) -> Void)
}

final class FileDataStorage: FileDataStorageService {
    
    private let userModelKey = "userModelKey"
    
    func writingData(user: UserModel, completion: @escaping (Result<UserModel, APIError>) -> Void) {
        
        if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = path.appendingPathComponent(userModelKey + ".text")
            
            do {
                try jsonEncoder(user: user).write(to: fileURL, atomically: false, encoding: .utf8)
                completion(.success(user))
            } catch {
                completion(.failure(.writingDataObjectError(error)))
            }
        }
    }
    
    func readingData(completion: @escaping (Result<UserModel, APIError>) -> Void) {
        
        if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = path.appendingPathComponent(userModelKey + ".text")
            
            do {
                let userData = try Data(contentsOf: fileURL, options: .mappedIfSafe)
                let decoder = JSONDecoder()
                
                let user = try decoder.decode(UserModel.self, from: userData)
                completion(.success(user))
            } catch {
                completion(.failure(.readingCoreDataObjectError(error)))
            }
        }
    }
    
    private func jsonEncoder(user: UserModel) -> String {
     
        do {
            let encodedData = try JSONEncoder().encode(user)
            let jsonString = String(data: encodedData, encoding: .utf8) ?? ""
            return jsonString
        } catch {
            return error.localizedDescription
        }
    }
}
