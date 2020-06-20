//
//  FillPersonalDataViewController.swift
//  XProject
//
//  Created by Максим Локтев on 08.04.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

protocol FillPersonalDataModuleOutput: class {

}

protocol FillPersonalDataModuleInput: class {

}

class FillPersonalDataViewController: UIViewController,
FillPersonalDataModuleInput, FillPersonalDataViewDelegate {

    // MARK: - Properties

    weak var moduleOutput: FillPersonalDataModuleOutput?

    var moduleView: FillPersonalDataView!
    
    private let dataManager = FillPersonalDataManager()

    // MARK: - View life cycle

    override func loadView() {
        moduleView = FillPersonalDataView(frame: UIScreen.main.bounds)
        moduleView.delegate = self
        view = moduleView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager.onPageSelected = { [weak self] page, title in
            self?.moduleView.setupPage(with: page, title: title)
            if page != 0 {
                self?.moduleView.endEditing(true)
            }
        }
        
        moduleView.setupDataManager(dataManager: dataManager)
        
        hideKeyboardWhenTappedAround()
        
        addObservers()
    }
    
    func viewDidTapNextButton(_ view: FillPersonalDataView) {
        let page = dataManager.setupNewPage()
        view.setupNewPage(page: page.index)
        
        if page.isLast {
            //moduleOutput?.greetingModuleDidShowAboutMe()
        }
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                               object: nil,
                                               queue: nil) { notification in
            self.keyboardWillShow(notification: notification)
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                               object: nil,
                                               queue: nil) { notification in
            self.keyboardWillHide(notification: notification)
        }
    }
    
    private func keyboardWillShow(notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else {
                return
        }
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
                self.moduleView.topTitleLabelConstraint?.update(inset: frame.height / 2)
                self.moduleView.topCarViewConstraint?.update(inset: frame.height + 8.0)
                self.moduleView.layoutIfNeeded()
        })
    }
    
    private func keyboardWillHide(notification: Notification) {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
                self.moduleView.topTitleLabelConstraint?.update(inset: 0.0)
                self.moduleView.topCarViewConstraint?.update(inset: 32.0)
                self.moduleView.layoutIfNeeded()
        })
    }
}
