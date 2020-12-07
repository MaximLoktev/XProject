//
//  NewFeedBuilder.swift
//  XProject
//
//  Created by Максим Локтев on 27.09.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

internal protocol NewsFeedBuildable {
    func build(withModuleOutput output: NewsFeedModuleOutput)
    -> UIViewController & NewsFeedModuleInput
}

internal class NewsFeedBuilder: NewsFeedBuildable {
    
    // MARK: - Properties
    
    private let sessionManager: SessionManager
    
    // MARK: - Init

    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }

    // MARK: - NewFeedBuildable
    
    func build(withModuleOutput output: NewsFeedModuleOutput) -> UIViewController & NewsFeedModuleInput {
        let viewController = NewsFeedViewController()
        let interactor = NewsFeedInteractor(sessionManager: sessionManager)
        let presenter = NewsFeedPresenter()
        viewController.interactor = interactor
        viewController.moduleOutput = output
        interactor.presenter = presenter
        presenter.viewController = viewController
        return viewController
    }
}
