//
//  RegistrationFillProfileCell.swift
//  XProject
//
//  Created by Максим Локтев on 18.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import SnapKit
import UIKit

class RegistrationFillProfileCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .darkGrey50
        label.backgroundColor = .clear
        
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        addSubview(titleLabel)
        
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(20.0)
        }
    }
}
