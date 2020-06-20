//
//  RegistrationViewController.swift
//  XProject
//
//  Created by Максим Локтев on 04.04.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

protocol RegistrationModuleOutput: class {

}

protocol RegistrationModuleInput: class {

}

class RegistrationViewController: UIViewController, RegistrationModuleInput, RegistrationViewDelegate {

    // MARK: - Properties

    weak var moduleOutput: RegistrationModuleOutput?

    var moduleView: RegistrationView!
    
    private let dataManager = ASAuthorizationDataManager()

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
