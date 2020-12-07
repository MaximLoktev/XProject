//
//  CreatePostPresenter.swift
//  XProject
//
//  Created by Максим Локтев on 25.10.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

internal protocol CreatePostPresentationLogic {
    func presentLoad(response: CreatePostDataFlow.Load.Response)
    func presentAddPostImage(response: CreatePostDataFlow.AddPostImage.Response)
    func presentDeletePostImage(response: CreatePostDataFlow.DeletePostImage.Response)
    func presentChangeTitlePost(response: CreatePostDataFlow.ChangeTitlePost.Response)
    func presentChangeDatePost(response: CreatePostDataFlow.ChangeDatePost.Response)
    func presentChangeGenderPost(response: CreatePostDataFlow.ChangeGenderPost.Response)
    func presentChangeDescriptionPost(response: CreatePostDataFlow.ChangeDescriptionPost.Response)
    func presentCreatePost(response: CreatePostDataFlow.CreatePost.Response)
}

internal class CreatePostPresenter: CreatePostPresentationLogic {

    // MARK: - Properties
    
    weak var viewController: CreatePostControllerLogic?

    // MARK: - CreatePostPresentationLogic
    
    func presentLoad(response: CreatePostDataFlow.Load.Response) {
        let items = makeItems(images: response.images)
        let viewModel = CreatePostDataFlow.Load.ViewModel(items: items)
        viewController?.displayLoad(viewModel: viewModel)
    }
    
    func presentAddPostImage(response: CreatePostDataFlow.AddPostImage.Response) {
        let items = makeItems(images: response.images)
        let viewModel = CreatePostDataFlow.AddPostImage.ViewModel(items: items)
        viewController?.displayAddPostImage(viewModel: viewModel)
    }
    
    func presentDeletePostImage(response: CreatePostDataFlow.DeletePostImage.Response) {
        let items = makeItems(images: response.images)
        let viewModel = CreatePostDataFlow.DeletePostImage.ViewModel(items: items)
        viewController?.displayDeletePostImage(viewModel: viewModel)
    }
    
    func presentChangeTitlePost(response: CreatePostDataFlow.ChangeTitlePost.Response) {
        let viewModel = CreatePostDataFlow.ChangeTitlePost.ViewModel(isWarningShow: response.isWarningShow,
                                                                     isValidData: response.isValidData,
                                                                     typeError: .title)
        viewController?.displayChangeTitlePost(viewModel: viewModel)
    }
    
    func presentChangeDatePost(response: CreatePostDataFlow.ChangeDatePost.Response) {
        let viewModel = CreatePostDataFlow.ChangeDatePost.ViewModel(isWarningShow: response.isWarningShow,
                                                                    isValidData: response.isValidData,
                                                                    typeError: .date)
        viewController?.displayChangeDatePost(viewModel: viewModel)
    }
    
    func presentChangeGenderPost(response: CreatePostDataFlow.ChangeGenderPost.Response) {
        let viewModel = CreatePostDataFlow.ChangeGenderPost.ViewModel(isWarningShow: response.isWarningShow,
                                                                      isValidData: response.isValidData,
                                                                      typeError: .gender)
        viewController?.displayChangeGenderPost(viewModel: viewModel)
    }
    
    func presentChangeDescriptionPost(response: CreatePostDataFlow.ChangeDescriptionPost.Response) {
        let viewModel = CreatePostDataFlow.ChangeDescriptionPost.ViewModel()
        viewController?.displayChangeDiscriptionPost(viewModel: viewModel)
    }
    
    func presentCreatePost(response: CreatePostDataFlow.CreatePost.Response) {
        let viewModel: CreatePostDataFlow.CreatePost.ViewModel
        
        switch response.result {
        case .success:
            viewModel = .success
        case .failure:
            viewModel = .failure(title: "Ошибка", description: "Не удалось создать пост")
        }
        viewController?.displayCreatePost(viewModel: viewModel)
    }
    
    private func makeItems(images: [UIImage]) -> [CreatePostDataFlow.Item] {
        var items: [CreatePostDataFlow.Item] = []
        let maxCardCount: Int = 3
        
        for image in images {
            items.append(CreatePostDataFlow.Item(image: image, state: .fill))
        }
        
        let range: Range = 0..<(maxCardCount - items.count)
        
        guard items.count < maxCardCount else {
            return items
        }
        
        for index in range {
            if index == range.first {
                items.append(CreatePostDataFlow.Item(image: #imageLiteral(resourceName: "Artboard"), state: .active))
            } else {
                items.append(CreatePostDataFlow.Item(image: #imageLiteral(resourceName: "Artboard Copy"), state: .empty))
            }
        }
        
        return items
    }
}
