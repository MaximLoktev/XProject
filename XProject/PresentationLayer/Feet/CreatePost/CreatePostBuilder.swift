//
//  CreatePostBuilder.swift
//  XProject
//
//  Created by Максим Локтев on 25.10.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

internal protocol CreatePostBuildable {
    func build(withModuleOutput output: CreatePostModuleOutput) -> UIViewController & CreatePostModuleInput
}

internal class CreatePostBuilder: CreatePostBuildable {
    
    // MARK: - Properties
    
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

    // MARK: - CreatePostBuildable
    
    func build(withModuleOutput output: CreatePostModuleOutput) -> UIViewController & CreatePostModuleInput {
        let viewController = CreatePostViewController()
        let interactor = CreatePostInteractor(profilleCoreDataService: profilleCoreDataService,
                                              newsFeedFirebaseService: newsFeedFirebaseService,
                                              sessionManager: sessionManager)
        let presenter = CreatePostPresenter()
        viewController.interactor = interactor
        viewController.moduleOutput = output
        interactor.presenter = presenter
        presenter.viewController = viewController
        return viewController
    }

}
