//
//  RegistrationFillProfilePresenter.swift
//  XProject
//
//  Created by Максим Локтев on 18.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import Foundation

internal protocol RegistrationFillProfilePresentationLogic {
    func presentLoad(response: RegistrationFillProfileDataFlow.Load.Response)
    func presentScrollTableViewIfNeeded(response: RegistrationFillProfileDataFlow.ScrollTableViewIfNeeded.Response)
    func presentNextPage(response: RegistrationFillProfileDataFlow.NextPage.Response)
    func presentCreateNamedImage(response: RegistrationFillProfileDataFlow.CreateNamedImage.Response)
    func presentSelectPage(response: RegistrationFillProfileDataFlow.SelectPage.Response)
    func presentAddUserImage(response: RegistrationFillProfileDataFlow.AddUserImage.Response)
    func presentSaveUserInFirebase(response: RegistrationFillProfileDataFlow.SaveUserInFirebase.Response)
    func presentEnterUserName(response: RegistrationFillProfileDataFlow.EnterUserName.Response)
    func presentGenderDidSelected(response: RegistrationFillProfileDataFlow.GenderDidSelected.Response)
}

internal class RegistrationFillProfilePresenter: RegistrationFillProfilePresentationLogic {

    // MARK: - Properties
    
    weak var viewController: RegistrationFillProfileControllerLogic?

    // MARK: - RegistrationFillProfilePresentationLogic

    func presentLoad(response: RegistrationFillProfileDataFlow.Load.Response) {
        let items = makeItems(profile: response.profile)
        let viewModel = RegistrationFillProfileDataFlow.Load.ViewModel(items: items)
        viewController?.displayLoad(viewModel: viewModel)
    }
    
    func presentScrollTableViewIfNeeded(response: RegistrationFillProfileDataFlow.ScrollTableViewIfNeeded.Response) {
        
        let items = makeItems(profile: response.profile)
        let item = items[response.index]
        let buttonTitle = item.buttonTitle
        
        let viewModel = RegistrationFillProfileDataFlow.ScrollTableViewIfNeeded.ViewModel(buttonTitle: buttonTitle,
                                                                                          index: response.index)
        viewController?.displayScrollTableViewIfNeeded(viewModel: viewModel)
    }
    
    func presentNextPage(response: RegistrationFillProfileDataFlow.NextPage.Response) {
        let viewModel: RegistrationFillProfileDataFlow.NextPage.ViewModel
        
        switch response {
        case let .success(profile, page):
            let items = makeItems(profile: profile)
            let isLastPage: Bool = page > items.count - 1
            let currentPage = isLastPage ? items.count - 1 : page
            
            var isNameFilled = false
            if case .name = items[page - 1].content {
                isNameFilled = true
            }
            let buttonTitle = items[currentPage].buttonTitle
            let content = RegistrationFillProfileDataFlow.PageContent(items: items,
                                                                      page: page,
                                                                      isLastPage: isLastPage,
                                                                      isNameFilled: isNameFilled,
                                                                      buttonTitle: buttonTitle)
            viewModel = .success(content: content)
        case .failure:
            viewModel = .failure(title: "Ошибка", description: "Не удалось загрузить следующую страницу!")
        }
        viewController?.displayNextPage(viewModel: viewModel)
    }
    
    func presentCreateNamedImage(response: RegistrationFillProfileDataFlow.CreateNamedImage.Response) {
        let viewModel: RegistrationFillProfileDataFlow.CreateNamedImage.ViewModel
        
        switch response.result {
        case .success:
            viewModel = .success
        case .failure:
            viewModel = .failure(title: "Ошибка", description: "Не удалось создать изображение!")
        }
        viewController?.displayCreateNamedImage(viewModel: viewModel)
    }
    
    func presentSelectPage(response: RegistrationFillProfileDataFlow.SelectPage.Response) {
        let items = makeItems(profile: response.profile)
        let buttonTitle = items[response.page].buttonTitle
        
        let viewModel = RegistrationFillProfileDataFlow.SelectPage.ViewModel(
            page: response.page,
            buttonTitle: buttonTitle
        )
        viewController?.displaySelectPage(viewModel: viewModel)
    }
    
    func presentAddUserImage(response: RegistrationFillProfileDataFlow.AddUserImage.Response) {
        let viewModel: RegistrationFillProfileDataFlow.AddUserImage.ViewModel
        
        switch response.result {
        case .success(let profile):
            let items = makeItems(profile: profile)
            viewModel = .success(items: items)
        case .failure:
            viewModel = .failure(title: "Ошибка", description: "Не удалось создать изображение!")
        }
        viewController?.displayAddUserImage(viewModel: viewModel)
    }
    
    func presentSaveUserInFirebase(response: RegistrationFillProfileDataFlow.SaveUserInFirebase.Response) {
        let viewModel: RegistrationFillProfileDataFlow.SaveUserInFirebase.ViewModel
        
        switch response.result {
        case .success:
            viewModel = .success
        case .failure:
            viewModel = .failure(title: "Ошибка", description: "Не удалось сохранить пользователя!")
        }
        viewController?.displaySaveUserInFirebase(viewModel: viewModel)
    }
    
    func presentEnterUserName(response: RegistrationFillProfileDataFlow.EnterUserName.Response) {
        let textError = "Поле не заполнено"
        let viewModel = RegistrationFillProfileDataFlow.EnterUserName.ViewModel(isWarningShow: response.isWarningShow,
                                                                                textError: textError)
        viewController?.displayEnterUserName(viewModel: viewModel)
    }
    
    func presentGenderDidSelected(response: RegistrationFillProfileDataFlow.GenderDidSelected.Response) {
        let isWarningShow = response.isWarningShow
        let textError = "Выберите пол"
        let viewModel = RegistrationFillProfileDataFlow.GenderDidSelected.ViewModel(isWarningShow: isWarningShow,
                                                                                    textError: textError)
        viewController?.displayGenderDidSelected(viewModel: viewModel)
    }
    
    private func makeItems(profile: RegistrationFillProfileDataFlow.Profile) -> [RegistrationFillProfileDataFlow.Item] {
        [
            RegistrationFillProfileDataFlow.Item(title: "Давай знакомиться.\nКак тебя зовут?",
                                                 content: .name(profile.name),
                                                 buttonTitle: "Далее"),
            RegistrationFillProfileDataFlow.Item(title: "Ваш пол",
                                                 content: .gender(profile.gender),
                                                 buttonTitle: "Далее"),
            RegistrationFillProfileDataFlow.Item(title: "Фото",
                                                 content: .image(profile.image),
                                                 buttonTitle: "Начать")
        ]
    }
}
