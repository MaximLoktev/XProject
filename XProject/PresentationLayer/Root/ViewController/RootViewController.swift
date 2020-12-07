//
//  RootViewController.swift
//  XProject
//
//  Created by Максим Локтев on 04.04.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import AuthenticationServices
import UIKit

protocol RootModuleOutput: class {
    
}

protocol RootModuleInput: class {
    
}

protocol RootBuilders {
    var registrationFillProfile: RegistrationFillProfileBuildable { get }
    var feed: FeedBuildable { get }
    var createPost: CreatePostBuildable { get }
    var editPost: EditPostBuildable { get }
}

struct BuildersContainer: RootBuilders, NewsFeedBuilders {
    
    let builders: RootBuilders
    
    init(builders: RootBuilders) {
        self.builders = builders
    }
    
    var registrationFillProfile: RegistrationFillProfileBuildable {
        builders.registrationFillProfile
    }
    
    var feed: FeedBuildable {
        builders.feed
    }
    
    var createPost: CreatePostBuildable {
        builders.createPost
    }
    
    var editPost: EditPostBuildable {
        builders.editPost
    }
}

class RootViewController: UITabBarController, RootModuleInput {
    
    // MARK: - Properties

    weak var moduleOutput: RootModuleOutput?
    
    private let appDependency: RootDependency
    
    private var newsFeetCoordinator: NewsFeedCoordinator?
    
    private var profileCoordinator: ProfileCoordinator?
    
    private let builders: RootBuilders
    
    private let rootNavigationController = UINavigationController()
    
    // MARK: - Init
    
    init(appDependency: RootDependency, builders: RootBuilders) {
        self.appDependency = appDependency
        self.builders = builders
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootNavigationController.navigationBar.isHidden = true
        startLoading()
    }
    
    // MARK: - RootControllerLogic
    
    private func startLoading() {
        //let haveSession = appDependency.sessionManager.haveSession()
        let haveSession = true
        var haveUser = false
        appDependency.profileCoreDataService.isUserCreated { isCreated in
            haveUser = isCreated
        }
        
        tabBar.isHidden = !haveSession || !haveUser
        
        if haveUser {
            setupMainControllers()
        } else if haveSession {
            let viewController = builders.registrationFillProfile.build(withModuleOutput: self)
            viewControllers = [viewController]
        } else {
            let viewController = RegistrationViewController(sessionManager: appDependency.sessionManager,
                                                            fileDataStorageService: appDependency.fileDataStorageService
            )
            viewController.moduleOutput = self
            rootNavigationController.setViewControllers([viewController], animated: false)
            viewControllers = [rootNavigationController]
        }
    }
    
    private func setupMainControllers() {
        
        let newsFeetViewController = startNewsFeetCoordinator()
        newsFeetViewController.tabBarItem = UITabBarItem.simpleIconItem(title: nil, image: #imageLiteral(resourceName: "feedIcon"), tag: 0)
        
        let profilleViewController = startProfilleCoordinator()
        profilleViewController.tabBarItem = UITabBarItem.simpleIconItem(title: nil, image: #imageLiteral(resourceName: "profileMinus1340"), tag: 1)

        setViewControllers([newsFeetViewController, profilleViewController], animated: true)
    }
    
    private func startNewsFeetCoordinator() -> UINavigationController {
        let navigationController = UINavigationController()
        
        newsFeetCoordinator = NewsFeedCoordinator(navigationController: navigationController,
                                                  profilleCoreDataService: appDependency.profileCoreDataService,
                                                  builders: BuildersContainer(builders: builders))
        newsFeetCoordinator?.start()
        
        return navigationController
    }
       
    private func startProfilleCoordinator() -> UINavigationController {
        let navigationController = UINavigationController()
           
        profileCoordinator = ProfileCoordinator(navigationController: navigationController,
                                                profileCoreDataService: appDependency.profileCoreDataService,
                                                profileFirebaseService: appDependency.profileFirebaseService)
        profileCoordinator?.start()
           
        return navigationController
    }
}

extension RootViewController: RegistrationModuleOutput {
    
    func asauthorizationModuleDidShowRegistration() {
        let viewController = builders.registrationFillProfile.build(withModuleOutput: self)
        rootNavigationController.pushViewController(viewController, animated: true)
    }
}

extension RootViewController: RegistrationFillProfileModuleOutput {
    
    func registrationFillProfileModuleDidShowNewsFeet() {
        tabBar.isHidden = false
        setupMainControllers()
    }
}
