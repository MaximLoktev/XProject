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
    
    private let sessionManager: SessionManager
    
    private let dataManager: ASAuthorizationDataManager
    
    // MARK: - Init
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        dataManager = ASAuthorizationDataManager(sessionManager: sessionManager)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
