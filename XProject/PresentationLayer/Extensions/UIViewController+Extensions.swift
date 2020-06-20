//
//  UIViewController+Extensions.swift
//  XProject
//
//  Created by Максим Локтев on 13.04.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func hideKeyboard() {
        view.endEditing(true)
    }
}
