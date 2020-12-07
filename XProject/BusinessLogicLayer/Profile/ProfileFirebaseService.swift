//
//  ProfileFirebaseService.swift
//  XProject
//
//  Created by Максим Локтев on 27.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import FirebaseDatabase
import FirebaseStorage

protocol ProfileFirebaseService {
    func saveProfile(key: String, parameters: [String: Any], completion: @escaping (Result<Void, APIError>) -> Void)
    func saveImage(imageName: String, completion: @escaping (Result<String, APIError>) -> Void)
    func saveImagesProfile(key: String, image: UIImage?, completion: @escaping (Result<String, APIError>) -> Void)
    func updateProfile(
        model: ProfileModel, image: UIImage, completion: @escaping (Result<ProfileModel, APIError>) -> Void)
}

class ProfileFirebaseServiceImpl: ProfileFirebaseService {

    private var databaseReference: DatabaseReference
    
    private let sessionManager: SessionManager
    
    init(databaseReference: DatabaseReference,
         sessionManager: SessionManager) {
        self.databaseReference = databaseReference
        self.sessionManager = sessionManager
    }
    
    func saveProfile(key: String, parameters: [String: Any], completion: @escaping (Result<Void, APIError>) -> Void) {
        databaseReference = Database.database().reference(withPath: "users").child(key)
        databaseReference.setValue(parameters) { error, _ in
            if let error = error {
                completion(.failure(.firebaseSaveProfileError(error)))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func saveImage(imageName: String, completion: @escaping (Result<String, APIError>) -> Void) {
        let userID = sessionManager.getUserId()
        
        let storageReference = Storage.storage().reference()
        let imagesReference = storageReference.child("images").child("iconUsers")
        let imageReference = imagesReference.child(userID)
        
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let fileURL = path.appendingPathComponent(imageName)
        imageReference.putFile(from: fileURL, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(.firebaseSaveImageError(error)))
                return
            }
            
            imageReference.downloadURL { url, error in
                guard let url = url else {
                    return
                }
                if let error = error {
                    completion(.failure(.firebaseSaveImageError(error)))
                    return
                }
                completion(.success(url.absoluteString))
            }
        }
    }
    
    func saveImagesProfile(key: String, image: UIImage?, completion: @escaping (Result<String, APIError>) -> Void) {
        let storageReference = Storage.storage().reference()
        let imagesReference = storageReference.child("images").child("iconUsers")
        
        guard let image = image else {
            return
        }
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        if let data = image.pngData() {
            let imageReference = imagesReference.child(key)
            imageReference.putData(data, metadata: metadata) { _, error in
                if let error = error {
                    completion(.failure(.firebaseSaveImageError(error)))
                    return
                }
                imageReference.downloadURL { url, error in
                    guard let url = url else {
                        return
                    }
                    if let error = error {
                        completion(.failure(.firebaseSaveImageError(error)))
                        return
                    }
                    completion(.success(url.absoluteString))
                }
            }
        }
    }
    
    func updateProfile(
        model: ProfileModel, image: UIImage, completion: @escaping (Result<ProfileModel, APIError>) -> Void) {
        var profileModel = model
        
        saveImagesProfile(key: profileModel.userId, image: image) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let imageUrl):
                profileModel.imageURL = imageUrl
                let parameters = self.jsonEncoded(model: profileModel)
                self.saveProfile(key: profileModel.userId, parameters: parameters) { result in
                    switch result {
                    case .success:
                        completion(.success(profileModel))
                    case .failure(let error):
                        completion(.failure(.firebaseSaveProfileError(error)))
                    }
                }
            case .failure(let error):
                completion(.failure(.firebaseSaveImageError(error)))
            }
        }
    }
    
    private func jsonEncoded(model: ProfileModel) -> [String: Any] {
        var jsonDictionary = [String: Any]()
        do {
            let json = try JSONEncoder().encodeJSONObject(model, options: [])
            jsonDictionary = json as? [String: Any] ?? [:]
        } catch {
            return [:]
        }
        return jsonDictionary
    }
}
