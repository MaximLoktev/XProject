//
//  ProfileCoordinator.swift
//  XProject
//
//  Created by Максим Локтев on 03.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

internal class ProfileCoordinator: NSObject {
    
    // MARK: - Properties
    
    private let navigationController: UINavigationController
    
    private let profileCoreDataService: ProfileCoreDataService
    
    private let profileFirebaseService: ProfileFirebaseService
    
    #warning("переделать билдер")
    private let editProfileBuilder: EditProfileBuildable
    
    // MARK: - Init
    
    init(navigationController: UINavigationController,
         profileCoreDataService: ProfileCoreDataService,
         profileFirebaseService: ProfileFirebaseService) {
        self.navigationController = navigationController
        self.profileCoreDataService = profileCoreDataService
        self.profileFirebaseService = profileFirebaseService
        
        self.editProfileBuilder = EditProfileBuilder(profileFirebaseService: profileFirebaseService,
                                                     profileCoreDataService: profileCoreDataService)
        super.init()
        
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func start() {
        let viewController = ProfileViewController(profileCoreDataService: profileCoreDataService)
        viewController.moduleOutput = self
        navigationController.setViewControllers([viewController], animated: true)
    }
}

extension ProfileCoordinator: ProfileModuleOutput {
    
    func profileModuleDidShowEditProfile(profileModel: ProfileModel) {
        let viewController = editProfileBuilder.build(withModuleOutput: self, profileModel: profileModel)
        navigationController.pushViewController(viewController, animated: true)
        navigationController.setNavigationBarHidden(false, animated: true)
        navigationController.tabBarController?.tabBar.isHidden = true
    }
}

extension ProfileCoordinator: EditProfileModuleOutput {
  
    func editProfileModuleDidBack() {
        navigationController.popViewController(animated: true)
        navigationController.setNavigationBarHidden(true, animated: true)
        navigationController.tabBarController?.tabBar.isHidden = false
    }
}
