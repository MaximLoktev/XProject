//
//  RegistrationFillProfileGenderCell.swift
//  XProject
//
//  Created by Максим Локтев on 18.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import SnapKit
import UIKit

class RegistrationFillProfileGenderCell: RegistrationFillProfileCell {
    
    // MARK: - Properties
    
    let genderPicker = InsetPickerView()
    
    var genderDidSelected: ((Gender) -> Void)?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        genderPicker.genderDidSelected = { [weak self] gender in
            self?.genderDidSelected?(gender)
        }
        genderPicker.selectRow(0, inComponent: 0, animated: true)
        
        addSubview(genderPicker)
        
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setupCell(title: String, gender: Gender) {
        titleLabel.text = title
        genderPicker.genderLvl = gender
        genderPicker.selectRow(gender.rawValue, inComponent: 0, animated: true)
    }
    
    // MARK: - Layout
    
    private func makeConstraints() {
        genderPicker.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(0.0)
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalTo(titleLabel.snp.right)
            make.bottom.equalToSuperview().offset(-6.0)
        }
    }
}
