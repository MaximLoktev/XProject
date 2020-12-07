//
//  RegistrationFillProfileBuilder.swift
//  XProject
//
//  Created by Максим Локтев on 18.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

internal protocol RegistrationFillProfileBuildable {
    func build(withModuleOutput output: RegistrationFillProfileModuleOutput)
        -> UIViewController & RegistrationFillProfileModuleInput
}

internal class RegistrationFillProfileBuilder: RegistrationFillProfileBuildable {

    // MARK: - Properties

    private let fileDataStorageService: FileDataStorageService
    
    private let profilleCoreDataService: ProfileCoreDataService
    
    private let imageLocalService: ImageService
    
    private let profileFirebaseService: ProfileFirebaseService
    
    private let sessionManager: SessionManager
    
    // MARK: - Init

    init(fileDataStorageService: FileDataStorageService,
         profilleCoreDataService: ProfileCoreDataService,
         imageLocalService: ImageService,
         profileFirebaseService: ProfileFirebaseService,
         sessionManager: SessionManager) {
        self.fileDataStorageService = fileDataStorageService
        self.profilleCoreDataService = profilleCoreDataService
        self.imageLocalService = imageLocalService
        self.profileFirebaseService = profileFirebaseService
        self.sessionManager = sessionManager
    }

    // MARK: - RegistrationFillProfileBuildable
    
    func build(withModuleOutput output: RegistrationFillProfileModuleOutput)
        -> UIViewController & RegistrationFillProfileModuleInput {
        let viewController = RegistrationFillProfileViewController()
        let interactor = RegistrationFillProfileInteractor(fileDataStorageService: fileDataStorageService,
                                                           profilleCoreDataService: profilleCoreDataService,
                                                           imageLocalService: imageLocalService,
                                                           profileFirebaseService: profileFirebaseService,
                                                           sessionManager: sessionManager)
        let presenter = RegistrationFillProfilePresenter()
        viewController.interactor = interactor
        viewController.moduleOutput = output
        interactor.presenter = presenter
        presenter.viewController = viewController
        return viewController
    }

}
