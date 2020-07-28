//
//  NewsFeetCoordinator.swift
//  XProject
//
//  Created by Максим Локтев on 03.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

internal class NewsFeetCoordinator: NSObject {
    
    // MARK: - Properties
    
    private let navigationController: UINavigationController
    
    private let profilleCoreDataService: ProfileCoreDataService
    
    // MARK: - Init
    
    init(navigationController: UINavigationController, profilleCoreDataService: ProfileCoreDataService) {
        self.navigationController = navigationController
        self.profilleCoreDataService = profilleCoreDataService
        super.init()
        
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func start() {
        let viewController = NewsFeetViewController(profilleCoreDataService: profilleCoreDataService)
        navigationController.setViewControllers([viewController], animated: true)
    }
}
