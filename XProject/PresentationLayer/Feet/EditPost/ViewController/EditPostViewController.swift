//
//  EditPostViewController.swift
//  XProject
//
//  Created by Максим Локтев on 12.11.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

internal protocol EditPostControllerLogic: class {
    func displayLoad(viewModel: EditPostDataFlow.Load.ViewModel)
    func displayAddPostImage(viewModel: EditPostDataFlow.AddPostImage.ViewModel)
    func displayDeletePostImage(viewModel: EditPostDataFlow.DeletePostImage.ViewModel)
    func displayChangeTitlePost(viewModel: EditPostDataFlow.ChangeTitlePost.ViewModel)
    func displayChangeDatePost(viewModel: EditPostDataFlow.ChangeDatePost.ViewModel)
    func displayChangeGenderPost(viewModel: EditPostDataFlow.ChangeGenderPost.ViewModel)
    func displayChangeDiscriptionPost(viewModel: EditPostDataFlow.ChangeDescriptionPost.ViewModel)
    func displaySavePost(viewModel: EditPostDataFlow.SavePost.ViewModel)
}

internal protocol EditPostModuleOutput: class {
    func editPostModuleDidBack()
}

internal protocol EditPostModuleInput: class {

}

internal class EditPostViewController: UIViewController,
    EditPostControllerLogic, EditPostModuleInput, EditPostViewDelegate {

    // MARK: - Properties

    var interactor: EditPostBusinessLogic?

    weak var moduleOutput: EditPostModuleOutput?

    var moduleView: EditPostView!
    
    private let dataManager = EditPostDataManager()

    // MARK: - View life cycle

    override func loadView() {
        moduleView = EditPostView(frame: UIScreen.main.bounds)
        moduleView.delegate = self
        view = moduleView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Редактирование Поста"
        
        startLoading()
        viewDidChangeGender()
        createdBarButton()
        setupDataManager()
    }
    
    // MARK: - EditPostControllerLogic
    
    private func startLoading() {
        let request = EditPostDataFlow.Load.Request()
        interactor?.load(request: request)
    }
    
    func displayLoad(viewModel: EditPostDataFlow.Load.ViewModel) {
        dataManager.items = viewModel.items
        moduleView.setupDataManager(dataManager: dataManager)
        moduleView.setupLoad(viewModel: viewModel)
    }
    
    func displayAddPostImage(viewModel: EditPostDataFlow.AddPostImage.ViewModel) {
        dataManager.items = viewModel.items
        moduleView.setupDataManager(dataManager: dataManager)
    }
    
    func displayDeletePostImage(viewModel: EditPostDataFlow.DeletePostImage.ViewModel) {
        dataManager.items = viewModel.items
        moduleView.setupDataManager(dataManager: dataManager)
    }
    
    func displayChangeTitlePost(viewModel: EditPostDataFlow.ChangeTitlePost.ViewModel) {
        moduleView.setupNameError(isErrorShow: viewModel.isWarningShow,
                                  isValidData: viewModel.isValidData,
                                  typeError: viewModel.typeError)
    }
    
    func displayChangeDatePost(viewModel: EditPostDataFlow.ChangeDatePost.ViewModel) {
        moduleView.setupNameError(isErrorShow: viewModel.isWarningShow,
                                  isValidData: viewModel.isValidData,
                                  typeError: viewModel.typeError)
    }
    
    func displayChangeGenderPost(viewModel: EditPostDataFlow.ChangeGenderPost.ViewModel) {
        moduleView.setupNameError(isErrorShow: viewModel.isWarningShow,
                                  isValidData: viewModel.isValidData,
                                  typeError: viewModel.typeError)
    }
    
    func displayChangeDiscriptionPost(viewModel: EditPostDataFlow.ChangeDescriptionPost.ViewModel) {
        //moduleView.setupCreatePostButton(isEnabled: viewModel.isValidData)
    }
    
    func displaySavePost(viewModel: EditPostDataFlow.SavePost.ViewModel) {
        IndicatorAlertController.hide()
        if case let .failure(title, description) = viewModel {
            let alert = AlertWindowController.alert(title: title, message: description, cancel: "Ok")
            alert.show()
        } else {
            moduleOutput?.editPostModuleDidBack()
        }
    }
    
    // MARK: - EditPostViewDelegate
    
    func viewDidChangeTitle(text: String) {
        let request = EditPostDataFlow.ChangeTitlePost.Request(text: text)
        interactor?.changeTitlePost(request: request)
    }
    
    func viewDidChangeDate(text: String, eventDate: Int, createDate: Int) {
        let request = EditPostDataFlow.ChangeDatePost.Request(text: text,
                                                              eventDate: eventDate,
                                                              createDate: createDate)
        interactor?.changeDatePost(request: request)
    }
    
    func viewDidChangeDescription(text: String) {
        let request = EditPostDataFlow.ChangeDescriptionPost.Request(text: text)
        interactor?.changeDescriptionPost(request: request)
    }
    
    func viewDidTapButton() {
        IndicatorAlertController.show()
        let request = EditPostDataFlow.SavePost.Request()
        interactor?.savePost(request: request)
    }
    
    private func viewDidChangeGender() {
        moduleView.genderDidSelected = { [weak self] gender in
            let request = EditPostDataFlow.ChangeGenderPost.Request(gender: gender)
            self?.interactor?.changeGenderPost(request: request)
        }
    }
    
    // MARK: - SettingsNavigation
    
    func setupSaveBarButtonItem(isEnabled: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = isEnabled
    }
    
    private func createdBarButton() {
        let saveBarButtonItem = UIBarButtonItem.saveBarButton(target: self, action: #selector(saveButtonAction))
        saveBarButtonItem.isEnabled = false
        navigationItem.rightBarButtonItem = saveBarButtonItem
        
        let backBarButtonItem = UIBarButtonItem.backBarButton(target: self, action: #selector(backButtonAction))
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    // MARK: - Actions
    
    @objc
    private func saveButtonAction () {
        IndicatorAlertController.show()
        let request = EditPostDataFlow.SavePost.Request()
        interactor?.savePost(request: request)
    }
    
    @objc
    private func backButtonAction () {
        moduleOutput?.editPostModuleDidBack()
    }
    
    // MARK: - Data manager
    
    private func setupDataManager() {
        dataManager.onImageTapped = { [weak self] in
            let alert = AlertWindowController.changePhotoAlert { sourceType in
                self?.setupPicker(sourceType: sourceType)
            }
            alert.show()
        }
        dataManager.onImageDelete = { image in
            let request = EditPostDataFlow.DeletePostImage.Request(image: image)
            self.interactor?.deletePostImage(request: request)
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension EditPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        dismiss(animated: true, completion: nil)
        
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        let request = EditPostDataFlow.AddPostImage.Request(image: image)
        interactor?.addPostImage(request: request)
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
