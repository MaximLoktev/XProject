//
//  RegistrationFillProfileInteractor.swift
//  XProject
//
//  Created by Максим Локтев on 18.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import Foundation

internal protocol RegistrationFillProfileBusinessLogic {
    func load(request: RegistrationFillProfileDataFlow.Load.Request)
    func nextPage(request: RegistrationFillProfileDataFlow.NextPage.Request)
    func createNamedImage(request: RegistrationFillProfileDataFlow.CreateNamedImage.Request)
    func selectPage(request: RegistrationFillProfileDataFlow.SelectPage.Request)
    func addUserImage(request: RegistrationFillProfileDataFlow.AddUserImage.Request)
}

internal class RegistrationFillProfileInteractor: RegistrationFillProfileBusinessLogic {

    // MARK: - Properties

    var presenter: RegistrationFillProfilePresentationLogic?
    
    private var userModel: UserModel?
    private var currentPage = 0
    
    private let fileDataStorageService: FileDataStorageService
    
    // MARK: - Init
    
    init(fileDataStorageService: FileDataStorageService) {
        self.fileDataStorageService = fileDataStorageService
    }
    
    // MARK: - RegistrationFillProfileBusinessLogic

    func load(request: RegistrationFillProfileDataFlow.Load.Request) {
        fileDataStorageService.readingData { [weak self] result in
            switch result {
            case.success(let user):
                self?.userModel = user
            case.failure:
                self?.userModel = UserModel(name: "", gender: .defaults, image: nil)
            }
            let response = RegistrationFillProfileDataFlow.Load.Response(userModel: self?.userModel)
            self?.presenter?.presentLoad(response: response)
        }
    }
    
    func nextPage(request: RegistrationFillProfileDataFlow.NextPage.Request) {
        switch request.content {
        case .name(let value):
            userModel?.name = value
        case .gender(let value):
            userModel?.gender = value
        case .image(let value):
            userModel?.image = value
        }
        currentPage += 1
        
        guard let userModel = userModel else {
            return
        }
        fileDataStorageService.writingData(user: userModel) { [weak self] result in
            guard let self = self else {
                return
            }
            let response: RegistrationFillProfileDataFlow.NextPage.Response
            
            switch result {
            case .success(let userModel):
                response = .success(userModel: userModel, page: self.currentPage)
            case .failure(let error):
                response = .failure(error: error)
            }

            self.presenter?.presentNextPage(response: response)
        }
    }
    
    func createNamedImage(request: RegistrationFillProfileDataFlow.CreateNamedImage.Request) {
        let image = LetterImageGenerator.imageWith(name: userModel?.name)
        let imageURL = LetterImageGenerator.storeImage(image: image)
        userModel?.image = imageURL
        
        guard let userModel = userModel else {
            return
        }
        
        fileDataStorageService.writingData(user: userModel) { [weak self] result in
            let response = RegistrationFillProfileDataFlow.CreateNamedImage.Response(result: result)
            self?.presenter?.presentCreateNamedImage(response: response)
        }
    }
    
    func selectPage(request: RegistrationFillProfileDataFlow.SelectPage.Request) {
        currentPage = request.page
        
        guard let userModel = userModel else {
            return
        }
        
        let response = RegistrationFillProfileDataFlow.SelectPage.Response(page: currentPage, userModel: userModel)
        self.presenter?.presentSelectPage(response: response)
    }
    
    func addUserImage(request: RegistrationFillProfileDataFlow.AddUserImage.Request) {
        let imageURL = LetterImageGenerator.storeImage(image: request.image)
        userModel?.image = imageURL
        
        guard let userModel = userModel else {
            return
        }
        
        fileDataStorageService.writingData(user: userModel) { [weak self] result in
            let response = RegistrationFillProfileDataFlow.AddUserImage.Response(result: result)
            self?.presenter?.presentAddUserImage(response: response)
        }
    }
//
//let imageURL = LetterImageGenerator.storeImage(image: image)
//userModel.image = imageURL
//
//fileDataStorageService.writingData(user: userModel) { [weak self] result in
//    guard let self = self else {
//        return
//    }
//    switch result {
//    case .success(let user):
//        userModel = user
//        self.dataManager.items = self.makeItems(image: image)
//        self.moduleView.collectionView.reloadData()
//    case .failure(let error):
//        _ = error.localizedDescription
//    }
//}
}
