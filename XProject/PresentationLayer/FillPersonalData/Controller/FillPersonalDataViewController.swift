//
//  FillPersonalDataViewController.swift
//  XProject
//
//  Created by Максим Локтев on 08.04.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

protocol FillPersonalDataModuleOutput: class {
    func fillPersonalDataModuleDidShowNewsFeet()
}

protocol FillPersonalDataModuleInput: class {

}

class FillPersonalDataViewController: UIViewController, FillPersonalDataModuleInput,
    FillPersonalDataViewDelegate {
    
    // MARK: - Properties

    weak var moduleOutput: FillPersonalDataModuleOutput?

    var moduleView: FillPersonalDataView!
    
    private var userModel: UserModel?
    
    private let fileDataStorageService: FileDataStorageService
    
    private let dataManager = FillPersonalDataManager()
    
    // MARK: - Init
    
    init(fileDataStorageService: FileDataStorageService) {
        self.fileDataStorageService = fileDataStorageService
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View life cycle

    override func loadView() {
        moduleView = FillPersonalDataView(frame: UIScreen.main.bounds)
        moduleView.delegate = self
        view = moduleView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fileDataStorageService.readingData { [weak self] result in
            switch result {
            case.success(let user):
                self?.userModel = user
            case.failure(let error):
                #warning("debug")
                self?.userModel = UserModel(name: "", gender: .defaults, image: nil)
                _ = error.localizedDescription
            }
        }
        
        setupDataManager()
        addObservers()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollTableViewIfNeeded()
    }
    
    func viewDidTapNextButton(_ view: FillPersonalDataView) {
        let page = dataManager.setupNewPage()
        view.setupNewPage(page: page.index)
        updatePersonalData(index: page.index, item: page.item)
        
        if page.isLast {
            moduleOutput?.fillPersonalDataModuleDidShowNewsFeet()
        }
    }
    
    private func scrollTableViewIfNeeded() {
        fileDataStorageService.readingData { [weak self] result in
            switch result {
            case.success(let user):
                DispatchQueue.main.async {
                    self?.scrollCell(user: user)
                }
            case.failure(let error):
                _ = error.localizedDescription
            }
        }
    }
    
    private func scrollCell(user: UserModel) {
//        let page = dataManager.setupNewPage()
        let item: Int
        if !user.name.isEmpty {
            if user.gender != .defaults {
                item = 2
            } else {
                item = 1
            }
        } else {
            item = 0
        }
        
        let items = dataManager.items
        let itemO = items[item]
        
        dataManager.currentPage = item
        moduleView.setupPage(with: item, title: itemO.buttonTitle)
        moduleView.setupNewPage(page: item)
    }
    
    private func stepSavingUser() {
        guard let userModel = userModel else {
            return
        }
        fileDataStorageService.writingData(user: userModel) { _ in
            
        }
    }
    
    private func updatePersonalData(index: Int, item: FillPersonalDataFlow.PersonalData) {
        
        let indexPath = IndexPath(row: index - 1, section: 0)
        let cell = moduleView.collectionView.cellForItem(at: indexPath)
        var newImage: UIImage?

        switch item.content {
        case .name:
            let name = (cell as? FillPersonalDataNameCell)?.name
            userModel?.name = name ?? ""
        case .gender:
            let gender = (cell as? FillPersonalDataGenderCell)?.genderPicker.genderLvl
            userModel?.gender = gender ?? .defaults
        case .image:
            let image = (cell as? FillPersonalDataImageCell)?.photoImageView.image
            let imageURL = LetterImageGenerator.storeImage(image: image)
            userModel?.image = imageURL
            newImage = image
        }
        
        stepSavingUser()
        dataManager.items = makeItems(image: newImage)
    }
    
    private func makeItems(image: UIImage? = nil) -> [FillPersonalDataFlow.PersonalData] {
        
        guard let userModel = userModel else {
            return []
        }
        
        return [
            FillPersonalDataFlow.PersonalData(title: "Давай знакомиться.\nКак тебя зовут?",
                                              content: .name(userModel.name),
                                              buttonTitle: "Далее"),
            FillPersonalDataFlow.PersonalData(title: "Ваш пол",
                                              content: .gender(userModel.gender),
                                              buttonTitle: "Далее"),
            FillPersonalDataFlow.PersonalData(title: "Фото",
                                              content: .image(userModel.name, image),
                                              buttonTitle: "Начать")
        ]
    }
    
    // MARK: - Data manager
    
    private func setupDataManager() {
        dataManager.items = makeItems()
        
        dataManager.onPageSelected = { [weak self] page, title in
            self?.moduleView.setupPage(with: page, title: title)
            if page != 0 {
                self?.moduleView.endEditing(true)
            }
        }
        
        dataManager.onImageTapped = { [weak self] in
            let alert = AlertWindowController.changePhotoAlert { sourceType in
                self?.setupPicker(sourceType: sourceType)
            }
            
            alert.show()
        }
        
        moduleView.setupDataManager(dataManager: dataManager)
    }
    
    // MARK: - Keyboard management
    
    private func addObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc
    private func keyboardWillShow(notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else {
                return
        }
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            self.moduleView.topTitleLabelConstraint?.update(inset: frame.height / 2)
            self.moduleView.topCarViewConstraint?.update(inset: frame.height + 8.0)
            self.moduleView.layoutIfNeeded()
        })
    }
    
    @objc
    private func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            self.moduleView.topTitleLabelConstraint?.update(inset: 0.0)
            self.moduleView.topCarViewConstraint?.update(inset: 32.0)
            self.moduleView.layoutIfNeeded()
        })
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension FillPersonalDataViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        dismiss(animated: true, completion: nil)
        
        guard let image = info[.editedImage] as? UIImage, var userModel = userModel else {
            return
        }
        
        let imageURL = LetterImageGenerator.storeImage(image: image)
        userModel.image = imageURL
        
        fileDataStorageService.writingData(user: userModel) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let user):
                userModel = user
                self.dataManager.items = self.makeItems(image: image)
                self.moduleView.collectionView.reloadData()
            case .failure(let error):
                _ = error.localizedDescription
            }
        }
    }
    
    func setupPicker(sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            DispatchQueue.main.async { [weak self] in
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = sourceType
                imagePickerController.allowsEditing = true
                imagePickerController.delegate = self
                imagePickerController.mediaTypes = ["public.image"]
                
                self?.present(imagePickerController, animated: true, completion: nil)
            }
        }
    }
    
}
