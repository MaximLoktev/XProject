//
//  RootViewController.swift
//  XProject
//
//  Created by Максим Локтев on 04.04.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import AuthenticationServices
import UIKit

protocol RootModuleInput: class {
    
}

class RootViewController: UITabBarController, RootModuleInput, RegistrationModuleOutput {
    
    // MARK: - Properties

    private let appDependency: RootDependency
    
    private var newsFeetCoordinator: NewsFeetCoordinator?
    private var profilleCoordinator: ProfilleCoordinator?
    
    // MARK: - Init
    
    init(appDependency: RootDependency) {
        self.appDependency = appDependency
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startLoading()
    }
    
    // MARK: - RootControllerLogic
    
    private func startLoading() {
        let haveSession = appDependency.sessionManager.haveSession()
        var haveUser = false
        appDependency.profilleCoreDataService.isUserCreated { isCreated in
            haveUser = isCreated
        }
        
        tabBar.isHidden = !haveSession || !haveUser
        
        if haveUser {
            setupMainControllers()
        } else if haveSession {
            let viewController = appDependency.registrationFillProfileBuilder.build(withModuleOutput: self)
            viewControllers = [viewController]
        } else {
            let viewController = RegistrationViewController(sessionManager: appDependency.sessionManager)
            viewController.moduleOutput = self
            viewControllers = [viewController]
        }
    }
    
    private func setupMainControllers() {
        
        let newsFeetViewController = startNewsFeetCoordinator()
        newsFeetViewController.tabBarItem = UITabBarItem.simpleIconItem(title: "Новости", image: #imageLiteral(resourceName: "fireIcon"), tag: 0)
        
        let profilleViewController = startProfilleCoordinator()
        profilleViewController.tabBarItem = UITabBarItem.simpleIconItem(title: "Профиль", image: #imageLiteral(resourceName: "profilleIcon"), tag: 1)

        setViewControllers([newsFeetViewController, profilleViewController], animated: true)
    }
    
    private func startNewsFeetCoordinator() -> UINavigationController {
        let navigationController = UINavigationController()
        
        newsFeetCoordinator = NewsFeetCoordinator(navigationController: navigationController,
                                                  profilleCoreDataService: appDependency.profilleCoreDataService)
        newsFeetCoordinator?.start()
        
        return navigationController
    }
       
    private func startProfilleCoordinator() -> UINavigationController {
        let navigationController = UINavigationController()
           
        profilleCoordinator = ProfilleCoordinator(navigationController: navigationController)
        profilleCoordinator?.start()
           
        return navigationController
    }
}

extension RootViewController: FillPersonalDataModuleOutput {
    
    func fillPersonalDataModuleDidShowNewsFeet() {
        tabBar.isHidden = false
        setupMainControllers()
    }
}

extension RootViewController: RegistrationFillProfileModuleOutput {
    
    func registrationFillProfileModuleDidShowNewsFeet() {
        tabBar.isHidden = false
        setupMainControllers()
    }
}
