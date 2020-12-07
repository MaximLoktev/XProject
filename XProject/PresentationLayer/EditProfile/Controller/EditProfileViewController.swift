//
//  EditProfileViewController.swift
//  XProject
//
//  Created by Максим Локтев on 09.10.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

internal protocol EditProfileControllerLogic: class {
    func displayLoad(viewModel: EditProfileDataFlow.Load.ViewModel)
    func displayChangeNameProfile(viewModel: EditProfileDataFlow.ChangeNameProfile.ViewModel)
    func displayChangeEmailProfile(viewModel: EditProfileDataFlow.ChangeEmailProfile.ViewModel)
    func displayChangeBirthdayProfile(viewModel: EditProfileDataFlow.ChangeBirthdayProfile.ViewModel)
    func displayChangeGenderProfile(viewModel: EditProfileDataFlow.ChangeGenderProfile.ViewModel)
    func displayEditProfileImage(viewModel: EditProfileDataFlow.EditProfileImage.ViewModel)
    func displayDeleteProfileImage(viewModel: EditProfileDataFlow.DeleteProfileImage.ViewModel)
    func displaySaveProfile(viewModel: EditProfileDataFlow.SaveProfile.ViewModel)
}

internal protocol EditProfileModuleOutput: class {
     func editProfileModuleDidBack()
}

internal protocol EditProfileModuleInput: class {

}

internal class EditProfileViewController: UIViewController,
                                          EditProfileControllerLogic, EditProfileModuleInput, EditProfileViewDelegate {
    
    // MARK: - Properties

    var interactor: EditProfileBusinessLogic?

    weak var moduleOutput: EditProfileModuleOutput?

    var moduleView: EditProfileView!

    // MARK: - View life cycle

    override func loadView() {
        moduleView = EditProfileView(frame: UIScreen.main.bounds)
        moduleView.delegate = self
        view = moduleView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationControllerSetting(navigationController: navigationController)
        navigationItem.title = "Редактирование"
        
        startLoading()
        createdBarButton()
        viewDidChangeGender()
    }

    // MARK: - EditProfileControllerLogic

    private func startLoading() {
        let request = EditProfileDataFlow.Load.Request()
        interactor?.load(request: request)
    }

    func displayLoad(viewModel: EditProfileDataFlow.Load.ViewModel) {
        moduleView.setupLoad(viewModel: viewModel)
    }
    
    func displayChangeNameProfile(viewModel: EditProfileDataFlow.ChangeNameProfile.ViewModel) {
        moduleView.setupNameError(isErrorShow: viewModel.isWarningShow,
                                  isValidData: viewModel.isValidData,
                                  typeError: viewModel.typeError)
    }
    
    func displayChangeEmailProfile(viewModel: EditProfileDataFlow.ChangeEmailProfile.ViewModel) {
        
    }
    
    func displayChangeBirthdayProfile(viewModel: EditProfileDataFlow.ChangeBirthdayProfile.ViewModel) {
        
    }
    
    func displayChangeGenderProfile(viewModel: EditProfileDataFlow.ChangeGenderProfile.ViewModel) {
        moduleView.setupNameError(isErrorShow: viewModel.isWarningShow,
                                  isValidData: viewModel.isValidData,
                                  typeError: viewModel.typeError)
    }
    
    func displayEditProfileImage(viewModel: EditProfileDataFlow.EditProfileImage.ViewModel) {
        moduleView.setupImage(image: viewModel.image, state: viewModel.state)
        moduleView.setupNameError(isErrorShow: viewModel.isWarningShow,
                                  isValidData: viewModel.isValidData,
                                  typeError: viewModel.typeError)
    }
    
    func displayDeleteProfileImage(viewModel: EditProfileDataFlow.DeleteProfileImage.ViewModel) {
        moduleView.setupImage(image: viewModel.image, state: viewModel.state)
        moduleView.setupNameError(isErrorShow: viewModel.isWarningShow,
                                  isValidData: viewModel.isValidData,
                                  typeError: viewModel.typeError)
    }
    
    func displaySaveProfile(viewModel: EditProfileDataFlow.SaveProfile.ViewModel) {
        IndicatorAlertController.hide()
        if case let .failure(title, description) = viewModel {
            let alert = AlertWindowController.alert(title: title, message: description, cancel: "Ok")
            alert.show()
        } else {
            moduleOutput?.editProfileModuleDidBack()
        }
    }
    
    // MARK: - EditProfileViewDelegate
    
    func viewDidChangeName(text: String) {
        let request = EditProfileDataFlow.ChangeNameProfile.Request(text: text)
        interactor?.changeNameProfile(request: request)
    }
    
    func viewDidChangeEmail(text: String) {
        let request = EditProfileDataFlow.ChangeEmailProfile.Request(text: text)
        interactor?.changeEmailProfile(request: request)
    }
    
    func viewDidChangeBirthday(birthday: Int) {
        let request = EditProfileDataFlow.ChangeBirthdayProfile.Request(birthday: birthday)
        interactor?.changeBirthdayProfile(request: request)
    }
    
    func editProfileImage() {
        let alert = AlertWindowController.changePhotoAlert { [weak self] sourceType in
            self?.setupPicker(sourceType: sourceType)
        }
        alert.show()
    }
    
    func deleteProfileImage(image: UIImage) {
        let request = EditProfileDataFlow.DeleteProfileImage.Request(image: image)
        interactor?.deleteProfileImage(request: request)
    }
    
    func viewDidTapButton() {
        IndicatorAlertController.show()
        let request = EditProfileDataFlow.SaveProfile.Request()
        interactor?.saveProfile(request: request)
    }
    
    private func viewDidChangeGender() {
        moduleView.genderDidSelected = { [weak self] gender in
            let request = EditProfileDataFlow.ChangeGenderProfile.Request(gender: gender)
            self?.interactor?.changeGenderProfile(request: request)
        }
    }
    
    // MARK: - SettingsNavigation
    
    func setupSaveBarButtonItem(isEnabled: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = isEnabled
    }
    
    private func createdBarButton() {
        let saveBarButtonItem = UIBarButtonItem.saveBarButton(target: self, action: #selector(saveButtonAction))
        navigationItem.rightBarButtonItem = saveBarButtonItem
        
        let backBarButtonItem = UIBarButtonItem.backBarButton(target: self, action: #selector(backButtonAction))
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    private func navigationControllerSetting(navigationController: UINavigationController?) {
        guard let navigationController = navigationController else {
            return
        }
        navigationController.navigationBar.barTintColor = .white
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19.0, weight: .medium)
        ]
    }
    
    // MARK: - Actions
    
    @objc
    private func saveButtonAction () {
//        IndicatorAlertController.show()
//        let request = EditPostDataFlow.SavePost.Request()
//        interactor?.savePost(request: request)
    }
    
    @objc
    private func backButtonAction () {
        moduleOutput?.editProfileModuleDidBack()
    }

}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        dismiss(animated: true, completion: nil)
        
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        let request = EditProfileDataFlow.EditProfileImage.Request(image: image)
        interactor?.editProfileImage(request: request)
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
