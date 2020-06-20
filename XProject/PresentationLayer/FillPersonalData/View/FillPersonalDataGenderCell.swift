//
//  FillPersonalGenderDataCell.swift
//  XProject
//
//  Created by Максим Локтев on 10.04.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import SnapKit
import UIKit

class FillPersonalDataGenderCell: FillPersonalDataCell {
    
    // MARK: - Properties
    
    private let genderPicker = InsetPickerView()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(genderPicker)
        
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setupCell(title: String) {
        titleLabel.text = title
    }
    
    // MARK: - Layout
    
    private func makeConstraints() {
        genderPicker.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8.0)
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalTo(titleLabel.snp.right)
            make.bottom.equalToSuperview()
        }
    }
}
