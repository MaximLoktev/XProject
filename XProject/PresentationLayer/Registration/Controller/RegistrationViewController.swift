//
//  RegistrationViewController.swift
//  XProject
//
//  Created by Максим Локтев on 04.04.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

internal protocol RegistrationModuleOutput: class {

}

internal protocol RegistrationModuleInput: class {

}

internal class RegistrationViewController: UIViewController, RegistrationModuleInput, RegistrationViewDelegate {

    // MARK: - Properties

    weak var moduleOutput: RegistrationModuleOutput?

    var moduleView: RegistrationView!
    
    private let dataManager: ASAuthorizationDataManager = ASAuthorizationDataManager()

    // MARK: - View life cycle

    override func loadView() {
        moduleView = RegistrationView(frame: UIScreen.main.bounds)
        moduleView.delegate = self
        view = moduleView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        moduleView.setupAuthorization(dataManager: dataManager)
    }
}
