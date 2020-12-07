//
//  CreatePostViewController.swift
//  XProject
//
//  Created by Максим Локтев on 25.10.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

internal protocol CreatePostControllerLogic: class {
    func displayLoad(viewModel: CreatePostDataFlow.Load.ViewModel)
    func displayAddPostImage(viewModel: CreatePostDataFlow.AddPostImage.ViewModel)
    func displayDeletePostImage(viewModel: CreatePostDataFlow.DeletePostImage.ViewModel)
    func displayChangeTitlePost(viewModel: CreatePostDataFlow.ChangeTitlePost.ViewModel)
    func displayChangeDatePost(viewModel: CreatePostDataFlow.ChangeDatePost.ViewModel)
    func displayChangeGenderPost(viewModel: CreatePostDataFlow.ChangeGenderPost.ViewModel)
    func displayChangeDiscriptionPost(viewModel: CreatePostDataFlow.ChangeDescriptionPost.ViewModel)
    func displayCreatePost(viewModel: CreatePostDataFlow.CreatePost.ViewModel)
}

internal protocol CreatePostModuleOutput: class {
    func createPostModuleDidBack()
}

internal protocol CreatePostModuleInput: class {

}

internal class CreatePostViewController: UIViewController,
    CreatePostControllerLogic, CreatePostModuleInput, CreatePostViewDelegate {

    // MARK: - Properties

    var interactor: CreatePostBusinessLogic?

    weak var moduleOutput: CreatePostModuleOutput?

    var moduleView: CreatePostView!
    
    private let dataManager = CreatePostDataManager()

    // MARK: - View life cycle

    override func loadView() {
        moduleView = CreatePostView(frame: UIScreen.main.bounds)
        moduleView.delegate = self
        view = moduleView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Создание Поста"
        
        startLoading()
        viewDidChangeGender()
        createdBarButton()
        setupDataManager()
    }
    
    // MARK: - CreatePostControllerLogic
    
    private func startLoading() {
        let request = CreatePostDataFlow.Load.Request()
        interactor?.load(request: request)
    }
    
    func displayLoad(viewModel: CreatePostDataFlow.Load.ViewModel) {
        dataManager.items = viewModel.items
        moduleView.setupDataManager(dataManager: dataManager)
        moduleView.setupLoad(viewModel: viewModel)
    }
    
    func displayAddPostImage(viewModel: CreatePostDataFlow.AddPostImage.ViewModel) {
        dataManager.items = viewModel.items
        moduleView.setupDataManager(dataManager: dataManager)
    }
    
    func displayDeletePostImage(viewModel: CreatePostDataFlow.DeletePostImage.ViewModel) {
        dataManager.items = viewModel.items
        moduleView.setupDataManager(dataManager: dataManager)
    }
    
    func displayChangeTitlePost(viewModel: CreatePostDataFlow.ChangeTitlePost.ViewModel) {
        moduleView.setupNameError(isErrorShow: viewModel.isWarningShow,
                                  isValidData: viewModel.isValidData,
                                  typeError: viewModel.typeError)
    }
    
    func displayChangeDatePost(viewModel: CreatePostDataFlow.ChangeDatePost.ViewModel) {
        moduleView.setupNameError(isErrorShow: viewModel.isWarningShow,
                                  isValidData: viewModel.isValidData,
                                  typeError: viewModel.typeError)
    }
    
    func displayChangeGenderPost(viewModel: CreatePostDataFlow.ChangeGenderPost.ViewModel) {
        moduleView.setupNameError(isErrorShow: viewModel.isWarningShow,
                                  isValidData: viewModel.isValidData,
                                  typeError: viewModel.typeError)
    }
    
    func displayChangeDiscriptionPost(viewModel: CreatePostDataFlow.ChangeDescriptionPost.ViewModel) {
        //moduleView.setupCreatePostButton(isEnabled: viewModel.isValidData)
    }
    
    func displayCreatePost(viewModel: CreatePostDataFlow.CreatePost.ViewModel) {
        IndicatorAlertController.hide()
        if case let .failure(title, description) = viewModel {
            let alert = AlertWindowController.alert(title: title, message: description, cancel: "Ok")
            alert.show()
        } else {
            moduleOutput?.createPostModuleDidBack()
        }
    }
    
    // MARK: - CreatePostViewDelegate
    
    func viewDidChangeTitle(text: String) {
        let request = CreatePostDataFlow.ChangeTitlePost.Request(text: text)
        interactor?.changeTitlePost(request: request)
    }
    
    func viewDidChangeDate(text: String, eventDate: Int, createDate: Int) {
        let request = CreatePostDataFlow.ChangeDatePost.Request(text: text,
                                                                eventDate: eventDate,
                                                                createDate: createDate)
        interactor?.changeDatePost(request: request)
    }
    
    func viewDidChangeDescription(text: String) {
        let request = CreatePostDataFlow.ChangeDescriptionPost.Request(text: text)
        interactor?.changeDescriptionPost(request: request)
    }
    
    func viewDidTapButton() {
        IndicatorAlertController.show()
        let request = CreatePostDataFlow.CreatePost.Request()
        interactor?.createPost(request: request)
    }
    
    private func viewDidChangeGender() {
        moduleView.genderDidSelected = { [weak self] gender in
            let request = CreatePostDataFlow.ChangeGenderPost.Request(gender: gender)
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
        let request = CreatePostDataFlow.CreatePost.Request()
        interactor?.createPost(request: request)
    }
    
    @objc
    private func backButtonAction () {
        moduleOutput?.createPostModuleDidBack()
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
            let request = CreatePostDataFlow.DeletePostImage.Request(image: image)
            self.interactor?.deletePostImage(request: request)
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension CreatePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        dismiss(animated: true, completion: nil)
        
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        let request = CreatePostDataFlow.AddPostImage.Request(image: image)
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
