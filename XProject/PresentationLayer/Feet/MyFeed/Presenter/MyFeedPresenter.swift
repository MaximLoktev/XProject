//
//  MyFeedPresenter.swift
//  XProject
//
//  Created by Максим Локтев on 27.09.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import Foundation

internal protocol MyFeedPresentationLogic {
    func presentLoad(response: MyFeedDataFlow.Load.Response)
    func presentRefresh(response: MyFeedDataFlow.Refresh.Response)
    func presentDeletePost(response: MyFeedDataFlow.Delete.Response)
}

internal class MyFeedPresenter: MyFeedPresentationLogic {

    // MARK: - Properties
    
    weak var viewController: MyFeedControllerLogic?

    // MARK: - MyFeedPresentationLogic

    func presentLoad(response: MyFeedDataFlow.Load.Response) {
        let viewModel: MyFeedDataFlow.Load.ViewModel

        switch response.result {
        case .success(let postModel):
            let isPlaceholderShow = postModel.isEmpty
            viewModel = .success(postModel: postModel, isPlaceholderShow: isPlaceholderShow)
        default:
            viewModel = .failure(title: "Ошибка", description: "Не удалось загрузить ленту")
        }
        viewController?.displayLoad(viewModel: viewModel)
    }

    func presentRefresh(response: MyFeedDataFlow.Refresh.Response) {
        let viewModel: MyFeedDataFlow.Refresh.ViewModel

        switch response.result {
        case .success(let postModel):
            let isPlaceholderShow = postModel.isEmpty
            viewModel = .success(postModel: postModel, isPlaceholderShow: isPlaceholderShow)
        default:
            viewModel = .failure(title: "Ошибка", description: "Не удалось загрузить ленту")
        }
        viewController?.displayRefresh(viewModel: viewModel)
    }
    
    func presentDeletePost(response: MyFeedDataFlow.Delete.Response) {
        let viewModel: MyFeedDataFlow.Delete.ViewModel
        
        switch response.result {
        case .success:
            viewModel = .success
        case .failure:
            viewModel = .failure(title: "Ошибка", description: "Не удалось удалить пост")
        }
        viewController?.displayDeletePost(viewModel: viewModel)
    }
    
}
