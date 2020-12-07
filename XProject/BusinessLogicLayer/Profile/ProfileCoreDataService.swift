//
//  ProfileCoreDataService.swift
//  XProject
//
//  Created by Максим Локтев on 27.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import Foundation

protocol ProfileCoreDataService {
    func createUser(model: ProfileModel, completion: @escaping (Result<ProfileModel, APIError>) -> Void)
    func fetchUser(completion: @escaping (Result<ProfileModel, APIError>) -> Void)
    func isUserCreated(completion: @escaping (Bool) -> Void)
}

class ProfilleCoreDataServiceImpl: ProfileCoreDataService {
    
    private let coreData: CoreData
    
    init(coreData: CoreData) {
        self.coreData = coreData
    }
    
    func createUser(model: ProfileModel, completion: @escaping (Result<ProfileModel, APIError>) -> Void) {
        let newUser = User(context: self.coreData.context)
        newUser.name = model.name
        newUser.gender = model.gender.description
        newUser.imageURL = model.imageURL
        newUser.email = model.email
        newUser.userId = model.userId
        newUser.birthday = Int64(model.birthday ?? 0)
        
        do {
            try self.coreData.context.save()
            completion(.success(model))
        } catch {
            completion(.failure(.createCoreDataObjectError(error)))
            _ = error.localizedDescription
        }
    }
    
    func fetchUser(completion: @escaping (Result<ProfileModel, APIError>) -> Void) {
        coreData.fetchObject(entity: User.self, context: coreData.context) { result in
            switch result {
            case .success(let user):
                let userModel = ProfileModel(name: user.name ?? "",
                                             birthday: Int(user.birthday),
                                             gender: user.gender ?? "",
                                             imageURL: user.imageURL ?? "",
                                             email: user.email ?? "",
                                             userId: user.userId ?? "")
                completion(.success(userModel))
            case .failure(let error):
                completion(.failure(.fetchCoreDataObjectError(error)))
            }
        }
    }
    
    func isUserCreated(completion: @escaping (Bool) -> Void) {
        coreData.fetchObject(entity: User.self, context: coreData.context) { result in
            switch result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }

    private func mapGender(gender: String) -> Gender? {
        switch gender {
        case "iOS":
            return .ios
        case "PHP":
            return .php
        case "Android":
            return .android
        case "defaults":
            return .defaults
        default:
            return nil
        }
    }
}
