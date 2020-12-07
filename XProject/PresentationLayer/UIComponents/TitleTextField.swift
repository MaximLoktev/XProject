//
//  TitleTextField.swift
//  XProject
//
//  Created by Максим Локтев on 25.10.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import SnapKit
import UIKit

internal class TitleTextField: UIView {
    
    // MARK: - Properies
    
    var textField: UITextField {
        titleTextField
    }
    
    var warningIsHidden: Bool {
        get {
            warningTitleLabel.isHidden
        }
        set {
            warningTitleLabel.isHidden = newValue
        }
    }
    
    var warningText: String? {
        get {
            warningTitleLabel.text
        }
        set {
            warningTitleLabel.text = newValue
        }
    }
    
//    @discardableResult
//    override func becomeFirstResponder() -> Bool {
//        if super.becomeFirstResponder() {
//            return true
//        } else {
//            titleTextField.becomeFirstResponder()
//            return false
//        }
//    }
    
    private let textFieldInputValidator: TextFieldInputValidator = AlphanumericsValidator()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textColor = .darkGrey50
        
        return label
    }()
    
    private let titleTextField = InputTextField()
    
    private let warningTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = .systemFont(ofSize: 13.0)
        label.isHidden = true
        
        return label
    }()
    
    // MARK: - Init
    
    init(title: String, warning: String) {
        super.init(frame: .zero)
        
        titleLabel.text = title
        warningTitleLabel.text = warning
    
        addSubview(titleLabel)
        addSubview(titleTextField)
        addSubview(warningTitleLabel)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    
    }
    
    // MARK: - Layout
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(15.0)
        }
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8.0)
            make.left.right.equalToSuperview()
            make.height.equalTo(56.0)
        }
        warningTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(4.0)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(15.0)
        }
    }
}
