//
//  EditPostInteractor.swift
//  XProject
//
//  Created by Максим Локтев on 12.11.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

internal protocol EditPostBusinessLogic {
    func load(request: EditPostDataFlow.Load.Request)
    func addPostImage(request: EditPostDataFlow.AddPostImage.Request)
    func deletePostImage(request: EditPostDataFlow.DeletePostImage.Request)
    func changeTitlePost(request: EditPostDataFlow.ChangeTitlePost.Request)
    func changeDatePost(request: EditPostDataFlow.ChangeDatePost.Request)
    func changeGenderPost(request: EditPostDataFlow.ChangeGenderPost.Request)
    func changeDescriptionPost(request: EditPostDataFlow.ChangeDescriptionPost.Request)
    func savePost(request: EditPostDataFlow.SavePost.Request)
}

internal class EditPostInteractor: EditPostBusinessLogic {
    
    // MARK: - Properties
    
    var presenter: EditPostPresentationLogic?
    
    private var postModel: PostModel
    
    private var imageUploadTasks: [UIImage] = []
    
    private let profilleCoreDataService: ProfileCoreDataService
    
    private let newsFeedFirebaseService: NewsFeedFirebaseService
    
    private let sessionManager: SessionManager
    
    // MARK: - Init
    
    init(profilleCoreDataService: ProfileCoreDataService,
         newsFeedFirebaseService: NewsFeedFirebaseService,
         sessionManager: SessionManager,
         postModel: PostModel) {
        self.profilleCoreDataService = profilleCoreDataService
        self.newsFeedFirebaseService = newsFeedFirebaseService
        self.sessionManager = sessionManager
        self.postModel = postModel
    }
    
    // MARK: - EditPostBusinessLogic
    
    func load(request: EditPostDataFlow.Load.Request) {
        guard let images = postModel.image else {
            return
        }
        for image in images {
            if let url = URL(string: image) {
                do {
                    let data = try Data(contentsOf: url)
                    if let image = UIImage(data: data) {
                        imageUploadTasks.append(image)
                    }
                } catch {
                    error.localizedDescription
                }
            }
            
        }
        
        let response = EditPostDataFlow.Load.Response(postModel: postModel, images: imageUploadTasks)
        presenter?.presentLoad(response: response)
    }
    
    func addPostImage(request: EditPostDataFlow.AddPostImage.Request) {
        imageUploadTasks.append(request.image)
        
        let response = EditPostDataFlow.AddPostImage.Response(images: imageUploadTasks)
        presenter?.presentAddPostImage(response: response)
    }
    
    func deletePostImage(request: EditPostDataFlow.DeletePostImage.Request) {
        guard let indexImage = imageUploadTasks.firstIndex(of: request.image) else {
            return
        }
        imageUploadTasks.remove(at: indexImage)
        let response = EditPostDataFlow.DeletePostImage.Response(images: imageUploadTasks)
        presenter?.presentDeletePostImage(response: response)
    }
    
    func changeTitlePost(request: EditPostDataFlow.ChangeTitlePost.Request) {
        postModel.title = request.text
        let isWarningShow = request.text.isEmpty
        let isValidData = isAllDataFilled()
        let response = EditPostDataFlow.ChangeTitlePost.Response(isWarningShow: isWarningShow,
                                                                 isValidData: isValidData)
        presenter?.presentChangeTitlePost(response: response)
    }
    
    func changeDatePost(request: EditPostDataFlow.ChangeDatePost.Request) {
        postModel.createDate = request.createDate
        postModel.date = request.eventDate
        let isWarningShow = request.text.isEmpty
        var isValidData: Bool
        if isWarningShow {
            isValidData = false
        } else {
            isValidData = isAllDataFilled()
        }
        let response = EditPostDataFlow.ChangeDatePost.Response(isWarningShow: isWarningShow,
                                                                isValidData: isValidData)
        presenter?.presentChangeDatePost(response: response)
    }
    
    func changeGenderPost(request: EditPostDataFlow.ChangeGenderPost.Request) {
        postModel.gender = request.gender.description
        let isWarningShow = request.gender == .defaults
        var isValidData: Bool
        if isWarningShow {
            isValidData = false
        } else {
            isValidData = isAllDataFilled()
        }
        let response = EditPostDataFlow.ChangeGenderPost.Response(isWarningShow: isWarningShow,
                                                                  isValidData: isValidData)
        presenter?.presentChangeGenderPost(response: response)
    }
    
    func changeDescriptionPost(request: EditPostDataFlow.ChangeDescriptionPost.Request) {
        postModel.description = request.text
        let response = EditPostDataFlow.ChangeDescriptionPost.Response()
        presenter?.presentChangeDescriptionPost(response: response)
    }
    
    func savePost(request: EditPostDataFlow.SavePost.Request) {
                
        profilleCoreDataService.fetchUser { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let user):
                self.postModel.creatorName = user.name
                self.postModel.icon = user.imageURL
                self.postModel.creatorId = user.userId
                
                self.newsFeedFirebaseService.updatePost(model: self.postModel,
                                                        images: self.imageUploadTasks) { result in
                    let presenterResponse: EditPostDataFlow.SavePost.Response
                    switch result {
                    case .success:
                        presenterResponse = EditPostDataFlow.SavePost.Response(result: .success(()))
                    case .failure(let error):
                        presenterResponse = EditPostDataFlow.SavePost.Response(
                                                           result: .failure(.firebaseSavePostError(error))
                        )
                    }
                    self.presenter?.presentSavePost(response: presenterResponse)
                }
            case .failure(let error):
                let response = EditPostDataFlow.SavePost.Response(
                    result: .failure(.firebaseSaveImagesPostError(error))
                )
                self.presenter?.presentSavePost(response: response)
            }
        }
    }
    
    private func isAllDataFilled() -> Bool {
        !postModel.title.isEmpty &&
        !postModel.date.isMultiple(of: 0) &&
        !postModel.gender.isEmpty
    }
}
