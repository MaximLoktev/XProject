//
//  ProfileCoreDataService.swift
//  XProject
//
//  Created by Максим Локтев on 27.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import Foundation

protocol ProfileCoreDataService {
    func createUser(model: ProfilleModel, completion: @escaping (Result<ProfilleModel, APIError>) -> Void)
    func fetchUser(completion: @escaping (Result<ProfilleModel, APIError>) -> Void)
    func isUserCreated(completion: @escaping (Bool) -> Void)
   // func mapFBSnapshot(value: NSDictionary?) -> ProfilleModel?
}

class ProfilleCoreDataServiceImpl: ProfileCoreDataService {
    
    private let coreData: CoreData
    
    init(coreData: CoreData) {
        self.coreData = coreData
    }
    
    func createUser(model: ProfilleModel, completion: @escaping (Result<ProfilleModel, APIError>) -> Void) {
        let newUser = User(context: self.coreData.context)
        newUser.name = model.name
        newUser.gender = model.gender.description
        newUser.imageURL = model.imageURL
        
        do {
            try self.coreData.context.save()
            completion(.success(model))
        } catch {
            completion(.failure(.createCoreDataObjectError(error)))
            _ = error.localizedDescription
        }
    }
    
    func fetchUser(completion: @escaping (Result<ProfilleModel, APIError>) -> Void) {
        coreData.fetchObject(entity: User.self, context: coreData.context) { result in
            switch result {
            case .success(let user):
                guard let gender = mapGender(gender: user.gender ?? "") else {
                    return
                }
                let user = ProfilleModel(name: user.name ?? "",
                                         gender: gender,
                                         imageURL: user.imageURL ?? "")
                completion(.success(user))
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
    
//    func mapFBSnapshot(value: NSDictionary?) -> ProfilleModel? {
//        guard let value = value else {
//            return nil
//        }
//        let name = value["name"] as? String ?? ""
//        let gender = value["gender"] as? String ?? ""
//        let imageURL = value["imageURL"] as? String ?? ""
//
//        return ProfilleModel(name: name,
//                             gender: gender,
//                             imageURL: imageURL)
//    }
//
//    private func mapUser(user: User) -> ProfilleModel? {
//        ProfilleModel(name: user.name ?? "",
//                      gender: user.gender ?? "",
//                      imageURL: user.imageURL ?? "")
//    }

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
