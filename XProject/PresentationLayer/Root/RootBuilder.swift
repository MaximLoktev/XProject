//
//  RootBuilder.swift
//  XProject
//
//  Created by Максим Локтев on 01.11.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

internal protocol RootBuildable {
    func build(withModuleOutput output: RootModuleOutput?) -> UITabBarController & RootModuleInput
}

private struct Builders: RootBuilders {
    var registrationFillProfile: RegistrationFillProfileBuildable
    var feed: FeedBuildable
    var createPost: CreatePostBuildable
    var editPost: EditPostBuildable
}

internal final class RootBuilder: RootBuildable {
    
    // MARK: - Properties
    
    let dependency: RootDependency
    
    // MARK: - Init
    
    init(dependency: RootDependency) {
        self.dependency = dependency
    }
    
    // MARK: - RootBuildable
    
    func build(withModuleOutput output: RootModuleOutput?) -> UITabBarController & RootModuleInput {
        let builders = Builders(
            registrationFillProfile: RegistrationFillProfileBuilder(
                fileDataStorageService: dependency.fileDataStorageService,
                profilleCoreDataService: dependency.profileCoreDataService,
                imageLocalService: dependency.imageService,
                profileFirebaseService: dependency.profileFirebaseService,
                sessionManager: dependency.sessionManager
            ),
            feed: FeedBuilder(profilleCoreDataService: dependency.profileCoreDataService,
                              sessionManager: dependency.sessionManager),
            createPost: CreatePostBuilder(profilleCoreDataService: dependency.profileCoreDataService,
                                          newsFeedFirebaseService: dependency.newFeedFirebaseService,
                                          sessionManager: dependency.sessionManager),
            editPost: EditPostBuilder(profilleCoreDataService: dependency.profileCoreDataService,
                                      newsFeedFirebaseService: dependency.newFeedFirebaseService,
                                      sessionManager: dependency.sessionManager)
        )
        let viewController = RootViewController(appDependency: dependency, builders: builders)
        return viewController
    }
    
}
