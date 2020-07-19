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
    func presentNextPage(response: RegistrationFillProfileDataFlow.NextPage.Response)
    func presentCreateNamedImage(response: RegistrationFillProfileDataFlow.CreateNamedImage.Response)
    func presentSelectPage(response: RegistrationFillProfileDataFlow.SelectPage.Response)
    func presentAddUserImage(response: RegistrationFillProfileDataFlow.AddUserImage.Response)
}

internal class RegistrationFillProfilePresenter: RegistrationFillProfilePresentationLogic {

    // MARK: - Properties
    
    weak var viewController: RegistrationFillProfileControllerLogic?

    // MARK: - RegistrationFillProfilePresentationLogic

    func presentLoad(response: RegistrationFillProfileDataFlow.Load.Response) {
        let items = makeItems(userModel: response.userModel)
        let viewModel = RegistrationFillProfileDataFlow.Load.ViewModel(items: items)
        viewController?.displayLoad(viewModel: viewModel)
    }
    
    func presentNextPage(response: RegistrationFillProfileDataFlow.NextPage.Response) {
        let viewModel: RegistrationFillProfileDataFlow.NextPage.ViewModel
        
        switch response {
        case let .success(userModel, page):
            let items = makeItems(userModel: userModel)
            let isLastPage: Bool = page > items.count - 1
            
            var isNameFilled = false
            if case .name = items[page - 1].content, userModel.image == nil {
                isNameFilled = true
            }
            let buttonTitle = items[page].buttonTitle
            let content = RegistrationFillProfileDataFlow.PageContent(
                items: items,
                page: page,
                isLastPage: isLastPage,
                isNameFilled: isNameFilled,
                buttonTitle: buttonTitle
            )
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
        let items = makeItems(userModel: response.userModel)
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
        case .success(let userModel):
            let items = makeItems(userModel: userModel)
            viewModel = .success(items: items)
        case .failure:
            viewModel = .failure(title: "Ошибка", description: "Не удалось создать изображение!")
        }
        viewController?.displayAddUserImage(viewModel: viewModel)
    }
    
    private func makeItems(userModel: UserModel?) -> [RegistrationFillProfileDataFlow.Item] {
        
        guard let userModel = userModel else {
            return []
        }
        
        return [
            RegistrationFillProfileDataFlow.Item(title: "Давай знакомиться.\nКак тебя зовут?",
                                                 content: .name(userModel.name),
                                                 buttonTitle: "Далее"),
            RegistrationFillProfileDataFlow.Item(title: "Ваш пол",
                                                 content: .gender(userModel.gender),
                                                 buttonTitle: "Далее"),
            RegistrationFillProfileDataFlow.Item(title: "Фото",
                                                 content: .image(userModel.image),
                                                 buttonTitle: "Начать")
        ]
    }
}
