//
//  RegistrationFillProfileInteractor.swift
//  XProject
//
//  Created by Максим Локтев on 18.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import FirebaseDatabase
import FirebaseStorage
import Foundation

internal protocol RegistrationFillProfileBusinessLogic {
    func load(request: RegistrationFillProfileDataFlow.Load.Request)
    func scrollTableViewIfNeeded(request: RegistrationFillProfileDataFlow.ScrollTableViewIfNeeded.Request)
    func nextPage(request: RegistrationFillProfileDataFlow.NextPage.Request)
    func createNamedImage(request: RegistrationFillProfileDataFlow.CreateNamedImage.Request)
    func selectPage(request: RegistrationFillProfileDataFlow.SelectPage.Request)
    func addUserImage(request: RegistrationFillProfileDataFlow.AddUserImage.Request)
    func saveUserInFirebase(request: RegistrationFillProfileDataFlow.SaveUserInFirebase.Request)
    func enterUserName(request: RegistrationFillProfileDataFlow.EnterUserName.Request)
    func genderDidSelected(request: RegistrationFillProfileDataFlow.GenderDidSelected.Request)
}

internal class RegistrationFillProfileInteractor: RegistrationFillProfileBusinessLogic {

    // MARK: - Properties

    var presenter: RegistrationFillProfilePresentationLogic?
    
    private var userModel: UserModel?
    private var coreData = CoreData()
    private var currentPage = 0
    private let userImageName = "userImageKey.png"
    
    private var ref: DatabaseReference = DatabaseReference()
    private let fileDataStorageService: FileDataStorageService
    private let profilleCoreDataService: ProfileCoreDataService
    
    // MARK: - Init
    
    init(fileDataStorageService: FileDataStorageService, profilleCoreDataService: ProfileCoreDataService) {
        self.fileDataStorageService = fileDataStorageService
        self.profilleCoreDataService = profilleCoreDataService
    }
    
    // MARK: - RegistrationFillProfileBusinessLogic

    func load(request: RegistrationFillProfileDataFlow.Load.Request) {
        fileDataStorageService.readingData { [weak self] result in
            switch result {
            case.success(let user):
                self?.userModel = user
            case.failure:
                self?.userModel = UserModel(name: "", gender: .defaults)
            }
            let response = RegistrationFillProfileDataFlow.Load.Response(userModel: self?.userModel)
            self?.presenter?.presentLoad(response: response)
        }
    }
    
    func scrollTableViewIfNeeded(request: RegistrationFillProfileDataFlow.ScrollTableViewIfNeeded.Request) {
        
        fileDataStorageService.readingData { [weak self] result in
            guard let self = self, let userModel = self.userModel else {
                return
            }
            
            switch result {
            case.success(let user):
                self.userModel = user
            case.failure(let error):
                _ = error.localizedDescription
            }
            
            let index: Int
            if !userModel.name.isEmpty {
                if userModel.gender != .defaults {
                    index = 2
                } else {
                    index = 1
                }
            } else {
                index = 0
            }
            self.currentPage = index
            
            let response = RegistrationFillProfileDataFlow.ScrollTableViewIfNeeded.Response(userModel: userModel,
                                                                                            index: index)
            self.presenter?.presentScrollTableViewIfNeeded(response: response)
        }
    }
    
    func nextPage(request: RegistrationFillProfileDataFlow.NextPage.Request) {
        switch request.content {
        case .name(let value):
            userModel?.name = value
        case .gender(let value):
            userModel?.gender = value
        case .image:
            break
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
        LetterImageGenerator.storeImage(image: image, name: userImageName)
        
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
        LetterImageGenerator.storeImage(image: request.image, name: userImageName)
        
        guard let userModel = userModel else {
            return
        }
        
        fileDataStorageService.writingData(user: userModel) { [weak self] result in
            let response = RegistrationFillProfileDataFlow.AddUserImage.Response(result: result)
            self?.presenter?.presentAddUserImage(response: response)
        }
    }
    
    func saveUserInFirebase(request: RegistrationFillProfileDataFlow.SaveUserInFirebase.Request) {
        let saveUserGroup = DispatchGroup()
        let saveUserQueue = DispatchQueue(label: "saveUserQueue")
        var localUserModel: UserModel?
        
        saveUserQueue.async {
            saveUserGroup.enter()
            self.fileDataStorageService.readingData { result in
                switch result {
                case.success(let userModel):
                    localUserModel = userModel
                case .failure(let error):
                    _ = error.localizedDescription
                }
                saveUserGroup.leave()
            }
        }
        
        saveUserGroup.wait()
        
        LetterImageGenerator.saveImageInFirebase(imageName: userImageName) { [weak self] result in
            guard let self = self, let userModel = localUserModel else {
                return
            }
            switch result {
            case .success(let imageUrl):
                self.ref = Database.database().reference(withPath: "users").child("user")
                self.ref.setValue(self.userModel?.convertToDictionary(imageUrl: imageUrl)) { _, _ in
                    let profilleModel = ProfilleModel(name: userModel.name,
                                                      gender: userModel.gender,
                                                      imageURL: imageUrl)
                    
                    self.profilleCoreDataService.createUser(model: profilleModel, completion: { result in
                        let presenterResponse: RegistrationFillProfileDataFlow.SaveUserInFirebase.Response
                        switch result {
                        case.success(let profilleModel):
                            presenterResponse =
                                RegistrationFillProfileDataFlow.SaveUserInFirebase.Response(
                                    result: .success(profilleModel))
                        case .failure(let error):
                            presenterResponse =
                                RegistrationFillProfileDataFlow.SaveUserInFirebase.Response(result: .failure(error))
                        }
                        self.presenter?.presentSaveUserInFirebase(response: presenterResponse)
                    })
                }
            case .failure(let error):
                 let response = RegistrationFillProfileDataFlow.SaveUserInFirebase.Response(result: .failure(error))
                 self.presenter?.presentSaveUserInFirebase(response: response)
            }
        }
    }
    
    func enterUserName(request: RegistrationFillProfileDataFlow.EnterUserName.Request) {
        let response = RegistrationFillProfileDataFlow.EnterUserName.Response(isWarningShow: request.text.isEmpty)
        self.presenter?.presentEnterUserName(response: response)
    }
    
    func genderDidSelected(request: RegistrationFillProfileDataFlow.GenderDidSelected.Request) {
        let isWarningShow = request.gender == .defaults
        let response = RegistrationFillProfileDataFlow.GenderDidSelected.Response(isWarningShow: isWarningShow)
        self.presenter?.presentGenderDidSelected(response: response)
    }
}

//                self.ref.observe(.value) { [weak self] snapshot in
//                    let value = snapshot.value as? NSDictionary
//                    guard let profilleModel = self?.profilleService.mapFBSnapshot(value: value) else {
//                        return
//                    }
//                    self?.profilleService.createUser(model: profilleModel, completion: { result in
//                        switch result {
//                        case.success(let profilleModel):
//                            print(profilleModel)
//                        case .failure(let error):
//                            _ = error.localizedDescription
//                        }
//                    })
//                }
