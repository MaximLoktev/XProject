//
//  MyFeedBuilder.swift
//  XProject
//
//  Created by Максим Локтев on 27.09.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

internal protocol MyFeedBuildable {
    func build(withModuleOutput output: MyFeedModuleOutput)
    -> UIViewController & MyFeedModuleInput
}

internal class MyFeedBuilder: MyFeedBuildable {
    
    // MARK: - Properties
    
    private let profilleCoreDataService: ProfileCoreDataService
    
    private let sessionManager: SessionManager
    
    // MARK: - Init

    init(profilleCoreDataService: ProfileCoreDataService,
         sessionManager: SessionManager) {
        self.profilleCoreDataService = profilleCoreDataService
        self.sessionManager = sessionManager
    }

    // MARK: - MyFeedBuildable
    
    func build(withModuleOutput output: MyFeedModuleOutput) -> UIViewController & MyFeedModuleInput {
        let viewController = MyFeedViewController()
        let interactor = MyFeedInteractor(profilleCoreDataService: profilleCoreDataService,
                                          sessionManager: sessionManager)
        let presenter = MyFeedPresenter()
        viewController.interactor = interactor
        viewController.moduleOutput = output
        interactor.presenter = presenter
        presenter.viewController = viewController
        return viewController
    }

}
