//
//  CreatePostInteractor.swift
//  XProject
//
//  Created by Максим Локтев on 25.10.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

internal protocol CreatePostBusinessLogic {
    func load(request: CreatePostDataFlow.Load.Request)
    func addPostImage(request: CreatePostDataFlow.AddPostImage.Request)
    func deletePostImage(request: CreatePostDataFlow.DeletePostImage.Request)
    func changeTitlePost(request: CreatePostDataFlow.ChangeTitlePost.Request)
    func changeDatePost(request: CreatePostDataFlow.ChangeDatePost.Request)
    func changeGenderPost(request: CreatePostDataFlow.ChangeGenderPost.Request)
    func changeDescriptionPost(request: CreatePostDataFlow.ChangeDescriptionPost.Request)
    func createPost(request: CreatePostDataFlow.CreatePost.Request)
}

internal class CreatePostInteractor: CreatePostBusinessLogic {
    
    // MARK: - Properties
    
    var presenter: CreatePostPresentationLogic?
    
    private var createPostModel = PostModel()
    
    private var imageUploadTasks: [UIImage] = []
    
    private let profilleCoreDataService: ProfileCoreDataService
    
    private let newsFeedFirebaseService: NewsFeedFirebaseService
    
    private let sessionManager: SessionManager
    
    // MARK: - Init
    
    init(profilleCoreDataService: ProfileCoreDataService,
         newsFeedFirebaseService: NewsFeedFirebaseService,
         sessionManager: SessionManager) {
        self.profilleCoreDataService = profilleCoreDataService
        self.newsFeedFirebaseService = newsFeedFirebaseService
        self.sessionManager = sessionManager
    }
    
    // MARK: - CreatePostBusinessLogic
    
    func load(request: CreatePostDataFlow.Load.Request) {
        let response = CreatePostDataFlow.Load.Response(images: imageUploadTasks)
        presenter?.presentLoad(response: response)
    }
    
    func addPostImage(request: CreatePostDataFlow.AddPostImage.Request) {
        imageUploadTasks.append(request.image)
        
        let response = CreatePostDataFlow.AddPostImage.Response(images: imageUploadTasks)
        presenter?.presentAddPostImage(response: response)
    }
    
    func deletePostImage(request: CreatePostDataFlow.DeletePostImage.Request) {
        guard let indexImage = imageUploadTasks.firstIndex(of: request.image) else {
            return
        }
        imageUploadTasks.remove(at: indexImage)
        let response = CreatePostDataFlow.DeletePostImage.Response(images: imageUploadTasks)
        presenter?.presentDeletePostImage(response: response)
    }
    
    func changeTitlePost(request: CreatePostDataFlow.ChangeTitlePost.Request) {
        createPostModel.title = request.text
        let isWarningShow = request.text.isEmpty
        let isValidData = isAllDataFilled()
        let response = CreatePostDataFlow.ChangeTitlePost.Response(isWarningShow: isWarningShow,
                                                                   isValidData: isValidData)
        presenter?.presentChangeTitlePost(response: response)
    }
    
    func changeDatePost(request: CreatePostDataFlow.ChangeDatePost.Request) {
        createPostModel.createDate = request.createDate
        createPostModel.date = request.eventDate
        let isWarningShow = request.text.isEmpty
        var isValidData: Bool
        if isWarningShow {
            isValidData = false
        } else {
            isValidData = isAllDataFilled()
        }
        let response = CreatePostDataFlow.ChangeDatePost.Response(isWarningShow: isWarningShow,
                                                                  isValidData: isValidData)
        presenter?.presentChangeDatePost(response: response)
    }
    
    func changeGenderPost(request: CreatePostDataFlow.ChangeGenderPost.Request) {
        createPostModel.gender = request.gender.description
        let isWarningShow = request.gender == .defaults
        var isValidData: Bool
        if isWarningShow {
            isValidData = false
        } else {
            isValidData = isAllDataFilled()
        }
        let response = CreatePostDataFlow.ChangeGenderPost.Response(isWarningShow: isWarningShow,
                                                                    isValidData: isValidData)
        presenter?.presentChangeGenderPost(response: response)
    }
    
    func changeDescriptionPost(request: CreatePostDataFlow.ChangeDescriptionPost.Request) {
        createPostModel.description = request.text
        let response = CreatePostDataFlow.ChangeDescriptionPost.Response()
        presenter?.presentChangeDescriptionPost(response: response)
    }
    
    func createPost(request: CreatePostDataFlow.CreatePost.Request) {
        
        profilleCoreDataService.fetchUser { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let user):
                self.createPostModel.creatorName = user.name
                self.createPostModel.icon = user.imageURL
                self.createPostModel.creatorId = user.userId
                
                self.newsFeedFirebaseService.createPost(model: self.createPostModel,
                                                        images: self.imageUploadTasks) { result in
                    let presenterResponse: CreatePostDataFlow.CreatePost.Response
                    switch result {
                    case .success:
                        presenterResponse = CreatePostDataFlow.CreatePost.Response(result: .success(()))
                    case .failure(let error):
                        presenterResponse = CreatePostDataFlow.CreatePost.Response(
                                                           result: .failure(.firebaseSavePostError(error))
                        )
                    }
                    self.presenter?.presentCreatePost(response: presenterResponse)
                }
            case .failure(let error):
                let response = CreatePostDataFlow.CreatePost.Response(
                    result: .failure(.firebaseSaveImagesPostError(error))
                )
                self.presenter?.presentCreatePost(response: response)
            }
        }
    }
    
    private func isAllDataFilled() -> Bool {
        !createPostModel.title.isEmpty &&
        !createPostModel.date.isMultiple(of: 0) &&
        !createPostModel.gender.isEmpty
    }
}
