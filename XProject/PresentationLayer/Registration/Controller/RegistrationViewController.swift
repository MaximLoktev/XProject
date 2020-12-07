//
//  RegistrationViewController.swift
//  XProject
//
//  Created by Максим Локтев on 04.04.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import AuthenticationServices
import UIKit

protocol RegistrationModuleOutput: class {
    func asauthorizationModuleDidShowRegistration()
}

protocol RegistrationModuleInput: class {

}

class RegistrationViewController: UIViewController, RegistrationModuleInput, RegistrationViewDelegate {

    // MARK: - Properties

    weak var moduleOutput: RegistrationModuleOutput?

    var moduleView: RegistrationView!
    
    private let sessionManager: SessionManager
    
    private let fileDataStorageService: FileDataStorageService
    
    private let dataManager: ASAuthorizationDataManager
    
    // MARK: - Init
    
    init(sessionManager: SessionManager, fileDataStorageService: FileDataStorageService) {
        self.sessionManager = sessionManager
        self.fileDataStorageService = fileDataStorageService
        dataManager = ASAuthorizationDataManager(sessionManager: sessionManager,
                                                 fileDataStorageService: fileDataStorageService)
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
        setupDataManager()
    }
    
    // MARK: - Setup DataManager
    
    private func setupDataManager() {
        dataManager.onUserAuthorization = { [weak self] result in
            switch result {
            case .success:
                self?.moduleOutput?.asauthorizationModuleDidShowRegistration()
            case .failure:
                let alert = AlertWindowController.alert(title: "Ошибка",
                                                        message: "Не удалось авторизироваться",
                                                        cancel: "Ok")
                alert.show()
            }
        }
        dataManager.onAuthorizationError = { _ in
            let alert = AlertWindowController.alert(title: "Ошибка",
                                                    message: "Для продолжения, нужно авторизироваться",
                                                    cancel: "Ok")
            alert.show()
        }
    }
}
