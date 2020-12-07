//
//  NewsFeedViewController.swift
//  XProject
//
//  Created by Максим Локтев on 27.09.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

internal protocol NewsFeedControllerLogic: class {
    func displayLoad(viewModel: NewsFeedDataFlow.Load.ViewModel)
    func displayRefresh(viewModel: NewsFeedDataFlow.Refresh.ViewModel)
}

internal protocol NewsFeedModuleOutput: class {

}

internal protocol NewsFeedModuleInput: class {
    func newsFeedModuleInputSelectFilter(title: String)
}

internal class NewsFeedViewController: UIViewController,
    NewsFeedControllerLogic, NewsFeedModuleInput, NewsFeedViewDelegate {

    // MARK: - Properties

    var interactor: NewsFeedBusinessLogic?

    weak var moduleOutput: NewsFeedModuleOutput?

    var moduleView: NewsFeedView!
    
    private let dataManager = NewsFeedDataManager()
    
    private var gender = "Все"
    
    // MARK: - View life cycle

    override func loadView() {
        moduleView = NewsFeedView(frame: UIScreen.main.bounds)
        moduleView.delegate = self
        view = moduleView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        startLoading()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshNewsFeed()
    }

    // MARK: - NewsFeedControllerLogic

    private func startLoading() {
        IndicatorAlertController.show()
        let request = NewsFeedDataFlow.Load.Request()
        interactor?.load(request: request)
    }

    func displayLoad(viewModel: NewsFeedDataFlow.Load.ViewModel) {
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
    
    func displayRefresh(viewModel: NewsFeedDataFlow.Refresh.ViewModel) {
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
    
    // MARK: - NewsFeedViewDelegate
    
    func refreshNewsFeed() {
        if gender == "Все" {
            let request = NewsFeedDataFlow.Load.Request()
            interactor?.load(request: request)
        } else {
            let request = NewsFeedDataFlow.Refresh.Request(title: gender)
            interactor?.refresh(request: request)
        }
    }
    
    // MARK: - NewsFeedModuleInput
    
    func newsFeedModuleInputSelectFilter(title: String) {
        gender = title
        if title == "Все" {
            let request = NewsFeedDataFlow.Load.Request()
            interactor?.load(request: request)
        } else {
            let request = NewsFeedDataFlow.Refresh.Request(title: title)
            interactor?.refresh(request: request)
        }
    }
}
