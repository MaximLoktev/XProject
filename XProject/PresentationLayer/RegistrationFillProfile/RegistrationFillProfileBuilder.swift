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
    
    // MARK: - Init

    init(fileDataStorageService: FileDataStorageService) {
        self.fileDataStorageService = fileDataStorageService
    }

    // MARK: - RegistrationFillProfileBuildable
    
    func build(withModuleOutput output: RegistrationFillProfileModuleOutput)
        -> UIViewController & RegistrationFillProfileModuleInput {
        let viewController = RegistrationFillProfileViewController()
        let interactor = RegistrationFillProfileInteractor(fileDataStorageService: fileDataStorageService)
        let presenter = RegistrationFillProfilePresenter()
        viewController.interactor = interactor
        viewController.moduleOutput = output
        interactor.presenter = presenter
        presenter.viewController = viewController
        return viewController
    }

}
