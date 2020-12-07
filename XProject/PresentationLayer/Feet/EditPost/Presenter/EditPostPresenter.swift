//
//  EditPostPresenter.swift
//  XProject
//
//  Created by Максим Локтев on 12.11.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

internal protocol EditPostPresentationLogic {
    func presentLoad(response: EditPostDataFlow.Load.Response)
    func presentAddPostImage(response: EditPostDataFlow.AddPostImage.Response)
    func presentDeletePostImage(response: EditPostDataFlow.DeletePostImage.Response)
    func presentChangeTitlePost(response: EditPostDataFlow.ChangeTitlePost.Response)
    func presentChangeDatePost(response: EditPostDataFlow.ChangeDatePost.Response)
    func presentChangeGenderPost(response: EditPostDataFlow.ChangeGenderPost.Response)
    func presentChangeDescriptionPost(response: EditPostDataFlow.ChangeDescriptionPost.Response)
    func presentSavePost(response: EditPostDataFlow.SavePost.Response)
}

internal class EditPostPresenter: EditPostPresentationLogic {

    // MARK: - Properties
    
    weak var viewController: EditPostControllerLogic?

    // MARK: - EditPostPresentationLogic
    
    func presentLoad(response: EditPostDataFlow.Load.Response) {
        let items = makeItems(images: response.images)
        let gender = makeGender(text: response.postModel.gender)
        let viewModel = EditPostDataFlow.Load.ViewModel(items: items,
                                                        postModel: response.postModel,
                                                        genderPost: gender)
        viewController?.displayLoad(viewModel: viewModel)
    }
    
    func presentAddPostImage(response: EditPostDataFlow.AddPostImage.Response) {
        let items = makeItems(images: response.images)
        let viewModel = EditPostDataFlow.AddPostImage.ViewModel(items: items)
        viewController?.displayAddPostImage(viewModel: viewModel)
    }
    
    func presentDeletePostImage(response: EditPostDataFlow.DeletePostImage.Response) {
        let items = makeItems(images: response.images)
        let viewModel = EditPostDataFlow.DeletePostImage.ViewModel(items: items)
        viewController?.displayDeletePostImage(viewModel: viewModel)
    }
    
    func presentChangeTitlePost(response: EditPostDataFlow.ChangeTitlePost.Response) {
        let viewModel = EditPostDataFlow.ChangeTitlePost.ViewModel(isWarningShow: response.isWarningShow,
                                                                   isValidData: response.isValidData,
                                                                   typeError: .title)
        viewController?.displayChangeTitlePost(viewModel: viewModel)
    }
    
    func presentChangeDatePost(response: EditPostDataFlow.ChangeDatePost.Response) {
        let viewModel = EditPostDataFlow.ChangeDatePost.ViewModel(isWarningShow: response.isWarningShow,
                                                                  isValidData: response.isValidData,
                                                                  typeError: .date)
        viewController?.displayChangeDatePost(viewModel: viewModel)
    }
    
    func presentChangeGenderPost(response: EditPostDataFlow.ChangeGenderPost.Response) {
        let viewModel = EditPostDataFlow.ChangeGenderPost.ViewModel(isWarningShow: response.isWarningShow,
                                                                    isValidData: response.isValidData,
                                                                    typeError: .gender)
        viewController?.displayChangeGenderPost(viewModel: viewModel)
    }
    
    func presentChangeDescriptionPost(response: EditPostDataFlow.ChangeDescriptionPost.Response) {
        let viewModel = EditPostDataFlow.ChangeDescriptionPost.ViewModel()
        viewController?.displayChangeDiscriptionPost(viewModel: viewModel)
    }
    
    func presentSavePost(response: EditPostDataFlow.SavePost.Response) {
        let viewModel: EditPostDataFlow.SavePost.ViewModel
        
        switch response.result {
        case .success:
            viewModel = .success
        case .failure:
            viewModel = .failure(title: "Ошибка", description: "Не удалось создать пост")
        }
        viewController?.displaySavePost(viewModel: viewModel)
    }
    
    private func makeItems(images: [UIImage]) -> [EditPostDataFlow.Item] {
        var items: [EditPostDataFlow.Item] = []
        let maxCardCount: Int = 3
        
        for image in images {
            items.append(EditPostDataFlow.Item(image: image, state: .fill))
        }
        
        let range: Range = 0..<(maxCardCount - items.count)
        
        guard items.count < maxCardCount else {
            return items
        }
        
        for index in range {
            if index == range.first {
                items.append(EditPostDataFlow.Item(image: #imageLiteral(resourceName: "Artboard"), state: .active))
            } else {
                items.append(EditPostDataFlow.Item(image: #imageLiteral(resourceName: "Artboard Copy"), state: .empty))
            }
        }
        
        return items
    }
    
    private func makeGender(text: String) -> Gender {
        switch text {
        case "Android":
            return .android
        case "iOS":
            return .ios
        case "PHP":
            return .php
        default:
            return .defaults
        }
    }
}
