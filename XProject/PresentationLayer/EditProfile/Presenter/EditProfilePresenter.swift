//
//  EditProfilePresenter.swift
//  XProject
//
//  Created by Максим Локтев on 09.10.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import Foundation

internal protocol EditProfilePresentationLogic {
    func presentLoad(response: EditProfileDataFlow.Load.Response)
    func presentChangeNameProfile(response: EditProfileDataFlow.ChangeNameProfile.Response)
    func presentChangeEmailProfile(response: EditProfileDataFlow.ChangeEmailProfile.Response)
    func presentChangeBirthdayProfile(response: EditProfileDataFlow.ChangeBirthdayProfile.Response)
    func presentChangeGenderProfile(response: EditProfileDataFlow.ChangeGenderProfile.Response)
    func presentEditProfileImage(response: EditProfileDataFlow.EditProfileImage.Response)
    func presentDeleteProfileImage(response: EditProfileDataFlow.DeleteProfileImage.Response)
    func presentSaveProfile(response: EditProfileDataFlow.SaveProfile.Response)
}

internal class EditProfilePresenter: EditProfilePresentationLogic {
    
    // MARK: - Properties
    
    weak var viewController: EditProfileControllerLogic?

    // MARK: - EditProfilePresentationLogic

    func presentLoad(response: EditProfileDataFlow.Load.Response) {
        let gender = makeGender(text: response.profileModel.gender)
        let viewModel = EditProfileDataFlow.Load.ViewModel(profileModel: response.profileModel,
                                                           gender: gender)
        viewController?.displayLoad(viewModel: viewModel)
    }
    
    func presentChangeNameProfile(response: EditProfileDataFlow.ChangeNameProfile.Response) {
        let viewModel = EditProfileDataFlow.ChangeNameProfile.ViewModel(isWarningShow: response.isWarningShow,
                                                                        isValidData: response.isValidData,
                                                                        typeError: .name)
        viewController?.displayChangeNameProfile(viewModel: viewModel)
    }
    
    func presentChangeEmailProfile(response: EditProfileDataFlow.ChangeEmailProfile.Response) {
        let viewModel = EditProfileDataFlow.ChangeEmailProfile.ViewModel()
        viewController?.displayChangeEmailProfile(viewModel: viewModel)
    }
    
    func presentChangeBirthdayProfile(response: EditProfileDataFlow.ChangeBirthdayProfile.Response) {
        let viewModel = EditProfileDataFlow.ChangeBirthdayProfile.ViewModel()
        viewController?.displayChangeBirthdayProfile(viewModel: viewModel)
    }
    
    func presentChangeGenderProfile(response: EditProfileDataFlow.ChangeGenderProfile.Response) {
        let viewModel = EditProfileDataFlow.ChangeGenderProfile.ViewModel(isWarningShow: response.isWarningShow,
                                                                          isValidData: response.isValidData,
                                                                          typeError: .gender)
        viewController?.displayChangeGenderProfile(viewModel: viewModel)
    }

    func presentEditProfileImage(response: EditProfileDataFlow.EditProfileImage.Response) {
        let viewModel = EditProfileDataFlow.EditProfileImage.ViewModel(image: response.image,
                                                                       isWarningShow: response.isWarningShow,
                                                                       isValidData: response.isValidData,
                                                                       typeError: .image,
                                                                       state: .fill)
        viewController?.displayEditProfileImage(viewModel: viewModel)
    }
    
    func presentDeleteProfileImage(response: EditProfileDataFlow.DeleteProfileImage.Response) {
        let viewModel = EditProfileDataFlow.DeleteProfileImage.ViewModel(image: response.image,
                                                                         isWarningShow: response.isWarningShow,
                                                                         isValidData: response.isValidData,
                                                                         typeError: .image,
                                                                         state: .active)
        viewController?.displayDeleteProfileImage(viewModel: viewModel)
    }
    
    func presentSaveProfile(response: EditProfileDataFlow.SaveProfile.Response) {
        let viewModel: EditProfileDataFlow.SaveProfile.ViewModel
        
        switch response.result {
        case .success:
            viewModel = .success
        case .failure:
            viewModel = .failure(title: "Ошибка", description: "Не удалось сохранить профиль")
        }
        viewController?.displaySaveProfile(viewModel: viewModel)
    }
    
    private func makeGender(text: String) -> Gender {
        switch text {
        case "Android":
            return .android
        case "iOS":
            return .ios
        case "PHP":
            return .php
        default:
            return .defaults
        }
    }
    
}
