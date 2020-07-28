//
//  RegistrationFillProfileViewController.swift
//  XProject
//
//  Created by Максим Локтев on 18.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

internal protocol RegistrationFillProfileControllerLogic: class {
    func displayLoad(viewModel: RegistrationFillProfileDataFlow.Load.ViewModel)
    func displayScrollTableViewIfNeeded(viewModel: RegistrationFillProfileDataFlow.ScrollTableViewIfNeeded.ViewModel)
    func displayNextPage(viewModel: RegistrationFillProfileDataFlow.NextPage.ViewModel)
    func displayCreateNamedImage(viewModel: RegistrationFillProfileDataFlow.CreateNamedImage.ViewModel)
    func displaySelectPage(viewModel: RegistrationFillProfileDataFlow.SelectPage.ViewModel)
    func displayAddUserImage(viewModel: RegistrationFillProfileDataFlow.AddUserImage.ViewModel)
    func displaySaveUserInFirebase(viewModel: RegistrationFillProfileDataFlow.SaveUserInFirebase.ViewModel)
    func displayEnterUserName(viewModel: RegistrationFillProfileDataFlow.EnterUserName.ViewModel)
    func displayGenderDidSelected(viewModel: RegistrationFillProfileDataFlow.GenderDidSelected.ViewModel)
}

internal protocol RegistrationFillProfileModuleOutput: class {
    func registrationFillProfileModuleDidShowNewsFeet()
}

internal protocol RegistrationFillProfileModuleInput: class {

}

internal class RegistrationFillProfileViewController: UIViewController,
    RegistrationFillProfileControllerLogic, RegistrationFillProfileModuleInput, RegistrationFillProfileViewDelegate {

    // MARK: - Properties

    var interactor: RegistrationFillProfileBusinessLogic?

    weak var moduleOutput: RegistrationFillProfileModuleOutput?

    var moduleView: RegistrationFillProfileView!
    
    private let dataManager = RegistrationFillProfileDataManager()

    // MARK: - View life cycle

    override func loadView() {
        moduleView = RegistrationFillProfileView(frame: UIScreen.main.bounds)
        moduleView.delegate = self
        view = moduleView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDataManager()
        startLoading()
        addObservers()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollTableViewIfNeeded()
    }

    // MARK: - RegistrationFillProfileControllerLogic

    private func startLoading() {
        let request = RegistrationFillProfileDataFlow.Load.Request()
        interactor?.load(request: request)
    }
    
    private func scrollTableViewIfNeeded() {
        let request = RegistrationFillProfileDataFlow.ScrollTableViewIfNeeded.Request()
        interactor?.scrollTableViewIfNeeded(request: request)
    }

    func displayLoad(viewModel: RegistrationFillProfileDataFlow.Load.ViewModel) {
        dataManager.items = viewModel.items
        moduleView.setupDataManager(dataManager: dataManager)
        moduleView.setupLoad(viewModel: viewModel)
    }
    
    func displayScrollTableViewIfNeeded(viewModel: RegistrationFillProfileDataFlow.ScrollTableViewIfNeeded.ViewModel) {
        moduleView.setupPage(with: viewModel.index, title: viewModel.buttonTitle)
        dataManager.currentPage = viewModel.index
        moduleView.scroll(to: viewModel.index, animated: false)
    }
    
    func displayNextPage(viewModel: RegistrationFillProfileDataFlow.NextPage.ViewModel) {
        switch viewModel {
        case .success(let content):
            dataManager.items = content.items
            dataManager.currentPage = content.page
            moduleView.reloadData()
            moduleView.setupPage(with: content.page, title: content.buttonTitle)
            
            if content.isNameFilled {
                let request = RegistrationFillProfileDataFlow.CreateNamedImage.Request()
                interactor?.createNamedImage(request: request)
            }
            
            if content.isLastPage {
                let request = RegistrationFillProfileDataFlow.SaveUserInFirebase.Request()
                interactor?.saveUserInFirebase(request: request)
            } else {
                moduleView.scroll(to: content.page, animated: true)
            }
        case let .failure(title, description):
            let alert = AlertWindowController.alert(title: title, message: description, cancel: "Ok")
            alert.show()
        }
    }
    
    func displayCreateNamedImage(viewModel: RegistrationFillProfileDataFlow.CreateNamedImage.ViewModel) {
        if case let .failure(title, description) = viewModel {
            let alert = AlertWindowController.alert(title: title, message: description, cancel: "Ok")
            alert.show()
        }
    }
    
    func displaySelectPage(viewModel: RegistrationFillProfileDataFlow.SelectPage.ViewModel) {
        moduleView.setupPage(with: viewModel.page, title: viewModel.buttonTitle)
        if viewModel.page != 0 {
            moduleView.endEditing(true)
        }
    }
    
    func displayAddUserImage(viewModel: RegistrationFillProfileDataFlow.AddUserImage.ViewModel) {
        switch viewModel {
        case .success(let items):
            dataManager.items = items
            moduleView.reloadData()
        case let .failure(title, description):
            let alert = AlertWindowController.alert(title: title, message: description, cancel: "Ok")
            alert.show()
        }
    }
    
    func displaySaveUserInFirebase(viewModel: RegistrationFillProfileDataFlow.SaveUserInFirebase.ViewModel) {
        if case let .failure(title, description) = viewModel {
            let alert = AlertWindowController.alert(title: title, message: description, cancel: "Ok")
            alert.show()
        }
        moduleOutput?.registrationFillProfileModuleDidShowNewsFeet()
    }
    
    func displayEnterUserName(viewModel: RegistrationFillProfileDataFlow.EnterUserName.ViewModel) {
        moduleView.setupNameError(isErrorShow: viewModel.isWarningShow, textError: viewModel.textError)
    }
    
    func displayGenderDidSelected(viewModel: RegistrationFillProfileDataFlow.GenderDidSelected.ViewModel) {
        moduleView.setupNameError(isErrorShow: viewModel.isWarningShow, textError: viewModel.textError)
    }
    
    // MARK: - RegistrationFillProfileViewDelegate
    
    func viewDidTapNextButton(_ view: RegistrationFillProfileView, content: RegistrationFillProfileDataFlow.Content) {
        let request = RegistrationFillProfileDataFlow.NextPage.Request(content: content)
        interactor?.nextPage(request: request)
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
    
    // MARK: - Data manager
    
    private func setupDataManager() {
        dataManager.onPageSelected = { [weak self] page in
            let request = RegistrationFillProfileDataFlow.SelectPage.Request(page: page)
            self?.interactor?.selectPage(request: request)
        }
        
        dataManager.onImageTapped = { [weak self] in
            let alert = AlertWindowController.changePhotoAlert { sourceType in
                self?.setupPicker(sourceType: sourceType)
            }
            alert.show()
        }
        
        dataManager.textFieldDidEditing = { [weak self] text in
            let request = RegistrationFillProfileDataFlow.EnterUserName.Request(text: text)
            self?.interactor?.enterUserName(request: request)
        }
        
        dataManager.genderDidSelected = { [weak self] gender in
            let request = RegistrationFillProfileDataFlow.GenderDidSelected.Request(gender: gender)
            self?.interactor?.genderDidSelected(request: request)
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension RegistrationFillProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        dismiss(animated: true, completion: nil)
        
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        let request = RegistrationFillProfileDataFlow.AddUserImage.Request(image: image)
        interactor?.addUserImage(request: request)
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
