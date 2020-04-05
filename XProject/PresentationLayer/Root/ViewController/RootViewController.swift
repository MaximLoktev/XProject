//
//  RootViewController.swift
//  XProject
//
//  Created by Максим Локтев on 04.04.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import AuthenticationServices
import UIKit

internal protocol RootModuleInput: class {
    
}

internal class RootViewController: UITabBarController, RootModuleInput {
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isHidden = true
        
        startLoading()
    }
    
    // MARK: - RootControllerLogic
    
    private func startLoading() {
        let viewController = RegistrationViewController()
        viewControllers = [viewController]
    }
}

//let viewController = RegistrationViewController()
//       viewController.tabBarItem = UITabBarItem(title: "Лента", image: nil, tag: 0)
//       viewControllers = [viewController]
