//
//  ProfilleCoordinator.swift
//  XProject
//
//  Created by Максим Локтев on 03.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

internal class ProfilleCoordinator: NSObject {
    
    // MARK: - Properties
    
    private let navigationController: UINavigationController
    
    // MARK: - Init
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func start() {
        let viewController = ProfilleViewController()
        navigationController.setViewControllers([viewController], animated: true)
    }
}
