//
//  RegistrationFillProfileNameCell.swift
//  XProject
//
//  Created by Максим Локтев on 18.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import SnapKit
import UIKit

class RegistrationFillProfileNameCell: RegistrationFillProfileCell {
    
    // MARK: - Properties
    
    var name: String {
        textField.text ?? ""
    }
    
    private let textField: InsetTextField = {
        let textField = InsetTextField()
        textField.font = .systemFont(ofSize: 17.0)
        textField.attributedPlaceholder =
            NSAttributedString(string: "Логин", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        textField.textColor = .darkGrey50
        textField.textAlignment = .left
        textField.backgroundColor = .clear
        textField.layer.cornerRadius = 12.0
        textField.clearButtonMode = .always
        textField.autocorrectionType = .no
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        return textField
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textField)
        
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setupCell(title: String, name: String) {
        titleLabel.text = title
        textField.text = name
    }
    
    // MARK: - Layout
    
    private func makeConstraints() {
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20.0)
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalTo(titleLabel.snp.right)
            make.height.equalTo(44.0)
        }
    }
}
