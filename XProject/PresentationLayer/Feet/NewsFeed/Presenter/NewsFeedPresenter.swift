//
//  NewsFeedPresenter.swift
//  XProject
//
//  Created by Максим Локтев on 27.09.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import Foundation

internal protocol NewsFeedPresentationLogic {
    func presentLoad(response: NewsFeedDataFlow.Load.Response)
    func presentRefresh(response: NewsFeedDataFlow.Refresh.Response)
}

internal class NewsFeedPresenter: NewsFeedPresentationLogic {

    // MARK: - Properties
    
    weak var viewController: NewsFeedControllerLogic?

    // MARK: - NewFeedPresentationLogic

    func presentLoad(response: NewsFeedDataFlow.Load.Response) {
        let viewModel: NewsFeedDataFlow.Load.ViewModel
        
        switch response.result {
        case .success(let postModel):
            let isPlaceholderShow = postModel.isEmpty
            viewModel = .success(postModel: postModel, isPlaceholderShow: isPlaceholderShow)
        default:
            viewModel = .failure(title: "Ошибка", description: "Не удалось загрузить ленту")
        }
        viewController?.displayLoad(viewModel: viewModel)
    }
    
    func presentRefresh(response: NewsFeedDataFlow.Refresh.Response) {
        let viewModel: NewsFeedDataFlow.Refresh.ViewModel
        
        switch response.result {
        case .success(let postModel):
            let isPlaceholderShow = postModel.isEmpty
            viewModel = .success(postModel: postModel, isPlaceholderShow: isPlaceholderShow)
        default:
            viewModel = .failure(title: "Ошибка", description: "Не удалось обновить ленту")
        }
        viewController?.displayRefresh(viewModel: viewModel)
    }

}
