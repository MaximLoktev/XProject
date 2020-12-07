//
//  ProfileViewController.swift
//  XProject
//
//  Created by Максим Локтев on 03.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

internal protocol ProfileModuleOutput: class {
    func profileModuleDidShowEditProfile(profileModel: ProfileModel)
}

internal protocol ProfileModuleInput: class {

}

internal class ProfileViewController: UIViewController, ProfileModuleInput, ProfileViewDelegate {

    // MARK: - Properties

    weak var moduleOutput: ProfileModuleOutput?

    var moduleView: ProfileView!
    
    private var profileModel: ProfileModel?
    
    private let dataManager = ProfileDataManager()
    
    private let profileCoreDataService: ProfileCoreDataService
    
    // MARK: - Init
    
    init(profileCoreDataService: ProfileCoreDataService) {
        self.profileCoreDataService = profileCoreDataService
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View life cycle

    override func loadView() {
        moduleView = ProfileView(frame: UIScreen.main.bounds)
        moduleView.delegate = self
        view = moduleView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
       // setupLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupLoad()
    }
    
    // MARK: - Setup
    
    private func setupLoad() {
        profileCoreDataService.fetchUser(completion: { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let user):
                let items = self.makeItems(user: user)
                self.profileModel = user
                self.dataManager.items = items
                self.moduleView.setupDataManager(dataManager: self.dataManager)
                self.moduleView.setupPhotoImage(image: user.imageURL)
            case.failure(let error):
                _ = error.localizedDescription
                let alertController =
                    AlertWindowController.alert(title: NSLocalizedString("Ошибка", comment: ""),
                                                message: NSLocalizedString("Не удалось создать аккаунт", comment: ""),
                                                cancel: NSLocalizedString("Ок", comment: ""))
                alertController.show()
            }
        })
    }
    
    // MARK: - Actions
    
    func viewDidTapNextButton() {
        guard let profileModel = profileModel else {
            return
        }
        moduleOutput?.profileModuleDidShowEditProfile(profileModel: profileModel)
    }
    
    private func makeItems(user: ProfileModel) -> [ProfileDataManager.Item] {
        var items: [ProfileDataManager.Item] = []
        items.append(.init(title: "Имя", description: user.name))
        items.append(.init(title: "Пол", description: user.gender.description))
        
        guard let email = user.email,
              let birthday = user.birthday,
              !birthday.isMultiple(of: 0),
              !email.isEmpty else {
            return items
        }
        items.append(.init(title: "E-mail", description: email))
        items.append(.init(title: "Дата рождения",
                           description: createDateFormatter(timeInterval: birthday)))

        return items
    }
    
    private func createDateFormatter(timeInterval: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let date = Date(timeIntervalSince1970: TimeInterval(timeInterval))
        let stringDate = dateFormatter.string(from: date)
        
        return stringDate
    }
}
