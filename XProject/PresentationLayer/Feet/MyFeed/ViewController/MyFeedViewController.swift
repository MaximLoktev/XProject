//
//  MyFeedViewController.swift
//  XProject
//
//  Created by Максим Локтев on 27.09.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

internal protocol MyFeedControllerLogic: class {
    func displayLoad(viewModel: MyFeedDataFlow.Load.ViewModel)
    func displayRefresh(viewModel: MyFeedDataFlow.Refresh.ViewModel)
    func displayDeletePost(viewModel: MyFeedDataFlow.Delete.ViewModel)
}

internal protocol MyFeedModuleOutput: class {
    func myFeedModuleDidShowEditPost(post: PostModel)
}

internal protocol MyFeedModuleInput: class {

}

internal class MyFeedViewController: UIViewController,
    MyFeedControllerLogic, MyFeedModuleInput, MyFeedViewDelegate {

    // MARK: - Properties

    var interactor: MyFeedBusinessLogic?

    weak var moduleOutput: MyFeedModuleOutput?

    var moduleView: MyFeedView!
    
    private let dataManager = MyFeedDataManager()

    // MARK: - View life cycle

    override func loadView() {
        moduleView = MyFeedView(frame: UIScreen.main.bounds)
        moduleView.delegate = self
        view = moduleView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        startLoading()
        setupDataManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshNewsFeed()
    }

    // MARK: - MyFeedControllerLogic

    private func startLoading() {
        IndicatorAlertController.show()
        let request = MyFeedDataFlow.Load.Request()
        interactor?.load(request: request)
    }

    func displayLoad(viewModel: MyFeedDataFlow.Load.ViewModel) {
        IndicatorAlertController.hide()
        switch viewModel {
        case let .success(postModel, isPlaceholderShow):
            dataManager.posts = postModel
            moduleView.setupDataManager(dataManager: dataManager)
            moduleView.setupPlaceholder(isPlaceholderShow: isPlaceholderShow)
        case let .failure(title, description):
            let alert = AlertWindowController.alert(title: title, message: description, cancel: "Ok")
            alert.show()
        }
        moduleView.setupLoad(viewModel: viewModel)
    }
    
    func displayRefresh(viewModel: MyFeedDataFlow.Refresh.ViewModel) {
        switch viewModel {
        case let .success(postModel, isPlaceholderShow):
            dataManager.posts = postModel
            moduleView.setupDataManager(dataManager: dataManager)
            moduleView.setupPlaceholder(isPlaceholderShow: isPlaceholderShow)
        case let .failure(title, description):
            let alert = AlertWindowController.alert(title: title, message: description, cancel: "Ok")
            alert.show()
        }
    }
    
    func displayDeletePost(viewModel: MyFeedDataFlow.Delete.ViewModel) {
        switch viewModel {
        case .success:
            refreshNewsFeed()
        case let .failure(title, description):
            let alert = AlertWindowController.alert(title: title, message: description, cancel: "Ok")
            alert.show()
        }
    }
    
    // MARK: - NewsFeedViewDelegate
    
    func refreshNewsFeed() {
        let request = MyFeedDataFlow.Refresh.Request()
        interactor?.refresh(request: request)
    }
    
    // MARK: - Data manager
    
    private func setupDataManager() {
        dataManager.onEditPostDidTapped = { [weak self] post in
            self?.moduleOutput?.myFeedModuleDidShowEditPost(post: post)
        }
        dataManager.onDeletePostDidTapped = { [weak self] post in
            let request = MyFeedDataFlow.Delete.Request(post: post)
            
            let alertController = AlertWindowController(title: "Предупреждение",
                                                        message: "Вы точно хотите удалить пост?",
                                                        preferredStyle: .alert)
            let done = UIAlertAction(title: "Да", style: .default) { _ in
                self?.interactor?.deletePost(request: request)
            }
            let cancel = UIAlertAction(title: "Нет", style: .cancel, handler: nil)
            alertController.addAction(done)
            alertController.addAction(cancel)
            alertController.show()
        }
    }
}
