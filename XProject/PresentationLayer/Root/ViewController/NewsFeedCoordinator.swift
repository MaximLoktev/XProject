//
//  NewsFeetCoordinator.swift
//  XProject
//
//  Created by Максим Локтев on 03.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

protocol NewsFeedBuilders {
    var feed: FeedBuildable { get }
    var createPost: CreatePostBuildable { get }
    var editPost: EditPostBuildable { get }
}

internal class NewsFeedCoordinator: NSObject {
    
    // MARK: - Properties
    
    private let navigationController: UINavigationController
    
    private let profilleCoreDataService: ProfileCoreDataService
    
    private let builders: NewsFeedBuilders
    
    // MARK: - Init
    
    init(navigationController: UINavigationController,
         profilleCoreDataService: ProfileCoreDataService,
         builders: NewsFeedBuilders) {
        self.navigationController = navigationController
        self.profilleCoreDataService = profilleCoreDataService
        self.builders = builders
        super.init()
        
        navigationController.setNavigationBarHidden(false, animated: false)
    }
    
    func start() {
        let viewController = builders.feed.build(withModuleOutput: self)
        navigationController.setViewControllers([viewController], animated: true)
    }
}

extension NewsFeedCoordinator: FeedModuleOutput {
    
    func feedModuleOutputDidSelectFilter(title: String) {
        for vc in navigationController.viewControllers where vc is FeedViewController {
            (vc as? FeedViewController)?.feetModuleInputSelectFilter(title: title)
        }
    }
    
    func feedModuleDidShowCreatePost() {
        let viewController = builders.createPost.build(withModuleOutput: self)
        navigationController.pushViewController(viewController, animated: true)
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.tabBarController?.tabBar.isHidden = true
    }
    
    func feedModuleDidShowEditPost(post: PostModel) {
        let viewController = builders.editPost.build(post: post, withModuleOutput: self)
        navigationController.pushViewController(viewController, animated: true)
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.tabBarController?.tabBar.isHidden = true
    }
}

extension NewsFeedCoordinator: CreatePostModuleOutput {
    
    func createPostModuleDidBack() {
        navigationController.popViewController(animated: true)
        navigationController.tabBarController?.tabBar.isHidden = false
    }
}

extension NewsFeedCoordinator: EditPostModuleOutput {
    
    func editPostModuleDidBack() {
        navigationController.popViewController(animated: true)
        navigationController.tabBarController?.tabBar.isHidden = false
    }
}
