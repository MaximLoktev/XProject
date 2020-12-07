//
//  EditProfileInteractor.swift
//  XProject
//
//  Created by Максим Локтев on 09.10.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

internal protocol EditProfileBusinessLogic {
    func load(request: EditProfileDataFlow.Load.Request)
    func changeNameProfile(request: EditProfileDataFlow.ChangeNameProfile.Request)
    func changeEmailProfile(request: EditProfileDataFlow.ChangeEmailProfile.Request)
    func changeBirthdayProfile(request: EditProfileDataFlow.ChangeBirthdayProfile.Request)
    func changeGenderProfile(request: EditProfileDataFlow.ChangeGenderProfile.Request)
    func editProfileImage(request: EditProfileDataFlow.EditProfileImage.Request)
    func deleteProfileImage(request: EditProfileDataFlow.DeleteProfileImage.Request)
    func saveProfile(request: EditProfileDataFlow.SaveProfile.Request)
}

internal class EditProfileInteractor: EditProfileBusinessLogic {

    // MARK: - Properties

    var presenter: EditProfilePresentationLogic?
    
    private var profileModel: ProfileModel
    
    private var imageProfile: UIImage?
    
    private let profileFirebaseService: ProfileFirebaseService
    
    private let profileCoreDataService: ProfileCoreDataService
    
    // MARK: - Init
    
    init(profileModel: ProfileModel,
         profileFirebaseService: ProfileFirebaseService,
         profileCoreDataService: ProfileCoreDataService) {
        self.profileModel = profileModel
        self.profileFirebaseService = profileFirebaseService
        self.profileCoreDataService = profileCoreDataService
    }
    
    // MARK: - EditProfileBusinessLogic

    func load(request: EditProfileDataFlow.Load.Request) {
        let response = EditProfileDataFlow.Load.Response(profileModel: profileModel)
        presenter?.presentLoad(response: response)
    }

    func changeNameProfile(request: EditProfileDataFlow.ChangeNameProfile.Request) {
        profileModel.name = request.text
        let isWarningShow = request.text.isEmpty
        let isValidData = isAllDataFilled()
        let response = EditProfileDataFlow.ChangeNameProfile.Response(isWarningShow: isWarningShow,
                                                                      isValidData: isValidData)
        presenter?.presentChangeNameProfile(response: response)
    }
    
    func changeEmailProfile(request: EditProfileDataFlow.ChangeEmailProfile.Request) {
        profileModel.email = request.text
        let response = EditProfileDataFlow.ChangeEmailProfile.Response()
        presenter?.presentChangeEmailProfile(response: response)
        
    }
    
    func changeBirthdayProfile(request: EditProfileDataFlow.ChangeBirthdayProfile.Request) {
        profileModel.birthday = request.birthday
        let response = EditProfileDataFlow.ChangeBirthdayProfile.Response()
        presenter?.presentChangeBirthdayProfile(response: response)
    }
    
    func changeGenderProfile(request: EditProfileDataFlow.ChangeGenderProfile.Request) {
        profileModel.gender = request.gender.description
        let isWarningShow = request.gender == .defaults
        var isValidData: Bool
        if isWarningShow {
            isValidData = false
        } else {
            isValidData = isAllDataFilled()
        }
        let response = EditProfileDataFlow.ChangeGenderProfile.Response(isWarningShow: isWarningShow,
                                                                        isValidData: isValidData)
        presenter?.presentChangeGenderProfile(response: response)
    }
    
    func editProfileImage(request: EditProfileDataFlow.EditProfileImage.Request) {
        imageProfile = request.image
        let isWarningShow = imageProfile != request.image
        var isValidData: Bool
        if isWarningShow {
            isValidData = false
        } else {
            isValidData = isAllDataFilled()
        }
        let response = EditProfileDataFlow.EditProfileImage.Response(image: request.image,
                                                                     isWarningShow: isWarningShow,
                                                                     isValidData: isValidData)
        presenter?.presentEditProfileImage(response: response)
    }
    
    func deleteProfileImage(request: EditProfileDataFlow.DeleteProfileImage.Request) {
        imageProfile = request.image
        let isWarningShow = imageProfile == request.image
        var isValidData: Bool
        if isWarningShow {
            isValidData = false
        } else {
            isValidData = isAllDataFilled()
        }
        let response = EditProfileDataFlow.DeleteProfileImage.Response(image: request.image,
                                                                       isWarningShow: isWarningShow,
                                                                       isValidData: isValidData)
        presenter?.presentDeleteProfileImage(response: response)
    }
    
    func saveProfile(request: EditProfileDataFlow.SaveProfile.Request) {
        guard let image = imageProfile else {
            return
        }
        profileFirebaseService.updateProfile(model: profileModel, image: image) { [weak self] result in
            switch result {
            case .success(let profileModel):
                self?.profileCoreDataService.createUser(model: profileModel, completion: { result in
                    let presenterResponse: EditProfileDataFlow.SaveProfile.Response
                    switch result {
                    case .success:
                        presenterResponse = EditProfileDataFlow.SaveProfile.Response(
                            result: .success(()))
                    case .failure(let error):
                        presenterResponse = EditProfileDataFlow.SaveProfile.Response(
                            result: .failure(.createCoreDataObjectError(error)))
                    }
                    self?.presenter?.presentSaveProfile(response: presenterResponse)
                })
            case .failure(let error):
                let response = EditProfileDataFlow.SaveProfile.Response(
                    result: .failure(.firebaseSaveProfileError(error)))
                self?.presenter?.presentSaveProfile(response: response)
            }
        }
    }
    
    private func isAllDataFilled() -> Bool {
        !profileModel.name.isEmpty &&
        !profileModel.gender.isEmpty &&
        !profileModel.imageURL.isEmpty
    }
    
}
