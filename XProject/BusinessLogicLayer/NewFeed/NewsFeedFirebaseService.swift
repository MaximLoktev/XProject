//
//  NewFeedFirebaseService.swift
//  XProject
//
//  Created by Максим Локтев on 11.10.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import FirebaseDatabase
import FirebaseStorage

protocol NewsFeedFirebaseService {
    func fetchFeedPosts(completion: @escaping (Result<[PostModel], APIError>) -> Void)
    func fetchPostsFilter(key: PostsFilter,
                          value: String,
                          completion: @escaping (Result<[PostModel], APIError>) -> Void)
    func savePost(key: String, parameters: [String: Any], completion: @escaping (Result<Void, APIError>) -> Void)
    func deletePost(key: String, completion: @escaping (Result<Void, APIError>) -> Void)
    func saveImagesPost(images: [UIImage], completion: @escaping (Result<[String], APIError>) -> Void)
    func createPost(model: PostModel, images: [UIImage], completion: @escaping (Result<Void, APIError>) -> Void)
    func updatePost(model: PostModel, images: [UIImage], completion: @escaping (Result<Void, APIError>) -> Void)
}

class NewsFeedFirebaseServiceImpl: NewsFeedFirebaseService {
    
    private var databaseReference: DatabaseReference
    
    private let sessionManager: SessionManager
    
    init(databaseReference: DatabaseReference, sessionManager: SessionManager) {
        self.databaseReference = databaseReference
        self.sessionManager = sessionManager
    }
    
    func fetchFeedPosts(completion: @escaping (Result<[PostModel], APIError>) -> Void) {
        databaseReference = Database.database().reference().child("feed").child("items")
        databaseReference.makeSimpleRequest(entity: [PostModel].self, completion: { result in
            switch result {
            case .success(let posts):
                completion(.success(posts))
            case.failure(let error):
                completion(.failure(.firebaseFetchNewFeedError(error)))
            }
        })
    }
    
    func fetchPostsFilter(key: PostsFilter,
                          value: String,
                          completion: @escaping (Result<[PostModel], APIError>) -> Void) {
        
        databaseReference = Database.database().reference().child("feed").child("items")
        databaseReference.queryOrdered(byChild: key.description).queryEqual(toValue: value)
            .makeSimpleRequest(entity: [PostModel].self, completion: { result in
                switch result {
                case .success(let posts):
                    completion(.success(posts))
                case.failure(let error):
                    completion(.failure(.firebaseFetchMyFeedPostError(error)))
                }
            })
    }
    
    func savePost(key: String, parameters: [String: Any], completion: @escaping (Result<Void, APIError>) -> Void) {
        databaseReference = Database.database().reference(withPath: "feed").child("items").child(key)
        databaseReference.setValue(parameters) { error, _ in
            if let error = error {
                completion(.failure(.firebaseSaveProfileError(error)))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func deletePost(key: String, completion: @escaping (Result<Void, APIError>) -> Void) {
        databaseReference = Database.database().reference(withPath: "feed").child("items").child(key)
        databaseReference.setValue(nil) { error, _ in
            if let error = error {
                completion(.failure(.firebaseDeletePostError(error)))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func saveImagesPost(images: [UIImage], completion: @escaping (Result<[String], APIError>) -> Void) {
        let postId = sessionManager.getPostId()
        let storageReference = Storage.storage().reference()
        let imagesReference = storageReference.child("images").child("imagesPost")
        
        guard !images.isEmpty else {
            return completion(.success([""]))
        }
        
        var imagesUrl: [String] = []
        let uploadGroup = DispatchGroup()
        
        for (index, image) in images.enumerated() {
            uploadGroup.enter()
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            
            if let data = image.pngData() {
                let imageReference = imagesReference.child(postId + index.description)
                imageReference.putData(data, metadata: metadata) { _, error in
                    if error != nil {
                        uploadGroup.leave()
                        return
                    }
                    imageReference.downloadURL { url, _ in
                        guard let url = url else {
                            uploadGroup.leave()
                            return
                        }
                        imagesUrl.append(url.absoluteString)
                        uploadGroup.leave()
                    }
                }
            } else {
                uploadGroup.leave()
            }
        }
        
        uploadGroup.notify(queue: .main) {
            if images.count < imagesUrl.count {
                completion(.failure(.firebaseSaveImagePostError))
            } else {
                completion(.success(imagesUrl))
            }
        }
    }
    
    func createPost(model: PostModel, images: [UIImage], completion: @escaping (Result<Void, APIError>) -> Void) {
        databaseReference = Database.database().reference(withPath: "feed").child("items").childByAutoId()
        guard let keyPost = databaseReference.key else {
            return
        }
        var postModel = model
        saveImagesPost(images: images) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let imagesUrl):
                postModel.image = imagesUrl
                postModel.id = keyPost
                let parameters = self.jsonEncoded(model: postModel)
                self.savePost(key: keyPost, parameters: parameters) { result in
                    switch result {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(.firebaseSavePostError(error)))
                    }
                }
            case .failure(let error):
                completion(.failure(.firebaseSaveImagesPostError(error)))
            }
        }
    }
    
    func updatePost(model: PostModel, images: [UIImage], completion: @escaping (Result<Void, APIError>) -> Void) {
        var postModel = model
        saveImagesPost(images: images) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let imagesUrl):
                postModel.image = imagesUrl
                let parameters = self.jsonEncoded(model: postModel)
                self.savePost(key: postModel.id, parameters: parameters) { result in
                    switch result {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(.firebaseSavePostError(error)))
                    }
                }
            case .failure(let error):
                completion(.failure(.firebaseSaveImagesPostError(error)))
            }
        }
    }
    
    private func jsonEncoded(model: PostModel) -> [String: Any] {
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
