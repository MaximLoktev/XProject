//
//  FeedBuilder.swift
//  XProject
//
//  Created by Максим Локтев on 15.10.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

internal protocol FeedBuildable {
    func build(withModuleOutput output: FeedModuleOutput) -> UIViewController & FeedModuleInput
}

private struct Builders: FeedModuleBuilders {
    let newsFeed: NewsFeedBuildable
    let myFeed: MyFeedBuildable
}

internal class FeedBuilder: FeedBuildable {
    
    // MARK: - Properties
    
    private let profilleCoreDataService: ProfileCoreDataService
    
    private let sessionManager: SessionManager
    
    // MARK: - Init

    init(profilleCoreDataService: ProfileCoreDataService,
         sessionManager: SessionManager) {
        self.profilleCoreDataService = profilleCoreDataService
        self.sessionManager = sessionManager
    }

    // MARK: - FeedBuildable
    
    func build(withModuleOutput output: FeedModuleOutput) -> UIViewController & FeedModuleInput {
        let builders = Builders(newsFeed: NewsFeedBuilder(sessionManager: sessionManager),
                                myFeed: MyFeedBuilder(profilleCoreDataService: profilleCoreDataService,
                                                      sessionManager: sessionManager))
        let viewController = FeedViewController(builders: builders)
        viewController.moduleOutput = output
        return viewController
    }

}
