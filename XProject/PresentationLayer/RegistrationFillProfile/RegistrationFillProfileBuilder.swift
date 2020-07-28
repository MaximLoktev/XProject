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
    
    // MARK: - Init

    init(fileDataStorageService: FileDataStorageService, profilleCoreDataService: ProfileCoreDataService) {
        self.fileDataStorageService = fileDataStorageService
        self.profilleCoreDataService = profilleCoreDataService
    }

    // MARK: - RegistrationFillProfileBuildable
    
    func build(withModuleOutput output: RegistrationFillProfileModuleOutput)
        -> UIViewController & RegistrationFillProfileModuleInput {
        let viewController = RegistrationFillProfileViewController()
            let interactor = RegistrationFillProfileInteractor(fileDataStorageService: fileDataStorageService,
                                                               profilleCoreDataService: profilleCoreDataService)
        let presenter = RegistrationFillProfilePresenter()
        viewController.interactor = interactor
        viewController.moduleOutput = output
        interactor.presenter = presenter
        presenter.viewController = viewController
        return viewController
    }

}
