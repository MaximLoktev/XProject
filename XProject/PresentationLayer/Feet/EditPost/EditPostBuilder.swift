//
//  EditPostBuilder.swift
//  XProject
//
//  Created by Максим Локтев on 12.11.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

internal protocol EditPostBuildable {
    func build(post: PostModel, withModuleOutput output: EditPostModuleOutput) -> UIViewController & EditPostModuleInput
}

internal class EditPostBuilder: EditPostBuildable {
    
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

    // MARK: - EditPostBuildable
    
    func build(
        post: PostModel, withModuleOutput output: EditPostModuleOutput) -> UIViewController & EditPostModuleInput {
        
        let viewController = EditPostViewController()
        let interactor = EditPostInteractor(profilleCoreDataService: profilleCoreDataService,
                                            newsFeedFirebaseService: newsFeedFirebaseService,
                                            sessionManager: sessionManager,
                                            postModel: post)
        let presenter = EditPostPresenter()
        viewController.interactor = interactor
        viewController.moduleOutput = output
        interactor.presenter = presenter
        presenter.viewController = viewController
        return viewController
    }
}
