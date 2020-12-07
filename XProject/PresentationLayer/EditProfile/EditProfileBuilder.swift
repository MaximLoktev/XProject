//
//  EditProfileBuilder.swift
//  XProject
//
//  Created by Максим Локтев on 09.10.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

internal protocol EditProfileBuildable {
    func build(withModuleOutput output: EditProfileModuleOutput,
               profileModel: ProfileModel) -> UIViewController & EditProfileModuleInput
}

internal class EditProfileBuilder: EditProfileBuildable {
    
    // MARK: - Properties
    
    private let profileFirebaseService: ProfileFirebaseService
    
    private let profileCoreDataService: ProfileCoreDataService
    
    // MARK: - Init
    
    init(profileFirebaseService: ProfileFirebaseService,
         profileCoreDataService: ProfileCoreDataService) {
        self.profileFirebaseService = profileFirebaseService
        self.profileCoreDataService = profileCoreDataService
    }

    // MARK: - EditProfileBuildable
    
    func build(withModuleOutput output: EditProfileModuleOutput,
               profileModel: ProfileModel) -> UIViewController & EditProfileModuleInput {
        let viewController = EditProfileViewController()
        let interactor = EditProfileInteractor(profileModel: profileModel,
                                               profileFirebaseService: profileFirebaseService,
                                               profileCoreDataService: profileCoreDataService)
        let presenter = EditProfilePresenter()
        viewController.interactor = interactor
        viewController.moduleOutput = output
        interactor.presenter = presenter
        presenter.viewController = viewController
        return viewController
    }

}
