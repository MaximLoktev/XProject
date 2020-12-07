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
    
    private var ref: DatabaseReference = DatabaseReference()
    private let fileDataStorageService: FileDataStorageService
    private let profilleCoreDataService: ProfileCoreDataService
    private let imageLocalService: ImageService
    private let profileFirebaseService: ProfileFirebaseService
    private let sessionManager: SessionManager
    
    // MARK: - Init
    
    init(fileDataStorageService: FileDataStorageService,
         profilleCoreDataService: ProfileCoreDataService,
         imageLocalService: ImageService,
         profileFirebaseService: ProfileFirebaseService,
         sessionManager: SessionManager) {
        self.fileDataStorageService = fileDataStorageService
        self.profilleCoreDataService = profilleCoreDataService
        self.imageLocalService = imageLocalService
        self.profileFirebaseService = profileFirebaseService
        self.sessionManager = sessionManager
    }
    
    // MARK: - RegistrationFillProfileBusinessLogic

    func load(request: RegistrationFillProfileDataFlow.Load.Request) {
        fileDataStorageService.readingData { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case.success(let user):
                self.userModel = user
                self.loadUserImage(userModel: user) { profile in
                    let response = RegistrationFillProfileDataFlow.Load.Response(profile: profile)
                    self.presenter?.presentLoad(response: response)
                }
            case.failure:
                let userModel = UserModel(name: "", gender: .defaults)
                self.userModel = userModel
                
                let profile = self.mapUserModel(userModel: userModel, image: nil)
                let response = RegistrationFillProfileDataFlow.Load.Response(profile: profile)
                self.presenter?.presentLoad(response: response)
            }
        }
    }
    
    private func loadUserImage(userModel: UserModel, completion: ((RegistrationFillProfileDataFlow.Profile) -> Void)?) {
        imageLocalService.loadImage(name: userModel.imageName) { [weak self] result in
            guard let self = self else {
                return
            }
            let profile: RegistrationFillProfileDataFlow.Profile
            switch result {
            case .success(let image):
                profile = self.mapUserModel(userModel: userModel, image: image)
            case .failure:
                profile = self.mapUserModel(userModel: userModel, image: nil)
            }
            completion?(profile)
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
            
            self.loadUserImage(userModel: userModel) { profile in
                let response = RegistrationFillProfileDataFlow.ScrollTableViewIfNeeded.Response(profile: profile,
                                                                                                index: index)
                self.presenter?.presentScrollTableViewIfNeeded(response: response)
            }
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
            switch result {
            case .success(let userModel):
                self.loadUserImage(userModel: userModel) { profile in
                    let response: RegistrationFillProfileDataFlow.NextPage.Response
                        = .success(profile: profile, page: self.currentPage)
                    self.presenter?.presentNextPage(response: response)
                }
            case .failure(let error):
                let response: RegistrationFillProfileDataFlow.NextPage.Response = .failure(error: error)
                self.presenter?.presentNextPage(response: response)
            }
        }
    }
    
    func createNamedImage(request: RegistrationFillProfileDataFlow.CreateNamedImage.Request) {
        guard let image = try? imageLocalService.imageWith(name: userModel?.name), let userModel = userModel else {
            return
        }

        var response: RegistrationFillProfileDataFlow.CreateNamedImage.Response!

        self.imageLocalService.storeImage(image: image, name: userModel.imageName) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success:
                self.fileDataStorageService.writingData(user: userModel) { result in
                    switch result {
                    case .success:
                        let profile = self.mapUserModel(userModel: userModel, image: image)
                        response = RegistrationFillProfileDataFlow.CreateNamedImage.Response(
                            result: .success(profile)
                        )
                    case .failure(let error):
                        response = RegistrationFillProfileDataFlow.CreateNamedImage.Response(
                            result: .failure(.fileDataStorageWriteError(error))
                        )
                    }
                    self.presenter?.presentCreateNamedImage(response: response)
                }
            case .failure:
                response = RegistrationFillProfileDataFlow.CreateNamedImage.Response(
                    result: .failure(.createImageLocalError)
                )
                self.presenter?.presentCreateNamedImage(response: response)
            }
        }
    }
    
    func selectPage(request: RegistrationFillProfileDataFlow.SelectPage.Request) {
        currentPage = request.page
        
        guard let userModel = userModel else {
            return
        }
        let profile = mapUserModel(userModel: userModel, image: nil)
        
        let response = RegistrationFillProfileDataFlow.SelectPage.Response(page: currentPage, profile: profile)
        self.presenter?.presentSelectPage(response: response)
    }
    
    func addUserImage(request: RegistrationFillProfileDataFlow.AddUserImage.Request) {
        guard let userModel = userModel else {
            return
        }
        
        imageLocalService.storeImage(image: request.image, name: userModel.imageName) { [weak self] result  in
            guard let self = self else {
                return
            }
            var response: RegistrationFillProfileDataFlow.AddUserImage.Response!
            switch result {
            case .success:
                self.fileDataStorageService.writingData(user: userModel) { result in
                    switch result {
                    case .success:
                        let profile = self.mapUserModel(userModel: userModel, image: request.image)
                        response = RegistrationFillProfileDataFlow.AddUserImage.Response(result: .success(profile))
                    case .failure(let error):
                        response = RegistrationFillProfileDataFlow.AddUserImage.Response(
                            result: .failure(.fileDataStorageWriteError(error))
                        )
                    }
                }
            case .failure(let error):
                response = RegistrationFillProfileDataFlow.AddUserImage.Response(
                    result: .failure(.storeImageLocalError(error))
                )
            }
            self.presenter?.presentAddUserImage(response: response)
        }
    }
    
    func saveUserInFirebase(request: RegistrationFillProfileDataFlow.SaveUserInFirebase.Request) {
        let saveUserGroup = DispatchGroup()
        var localUserModel: UserModel?
        
        saveUserGroup.enter()
        fileDataStorageService.readingData { result in
            switch result {
            case.success(let userModel):
                localUserModel = userModel
            case .failure(let error):
                _ = error.localizedDescription
            }
            saveUserGroup.leave()
        }
        saveUserGroup.wait()
        
        guard let userModel = localUserModel else {
            return
        }
        profileFirebaseService.saveImage(imageName: userModel.imageName) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let imageUrl):
                #warning("Доработать токен")
                let userId = self.sessionManager.getUserId()
                let parameters = userModel.convertToDictionary(imageUrl: imageUrl, token: userId)
                self.profileFirebaseService.saveProfile(key: userId, parameters: parameters) { result in
                    let profilleModel = ProfileModel(name: userModel.name,
                                                     gender: userModel.gender.description,
                                                     imageURL: imageUrl,
                                                     email: userModel.email,
                                                     userId: userId)
                    
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
    
    private func mapUserModel(userModel: UserModel, image: UIImage?) -> RegistrationFillProfileDataFlow.Profile {
        RegistrationFillProfileDataFlow.Profile(name: userModel.name, gender: userModel.gender, image: image)
    }
}
