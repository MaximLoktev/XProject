//
//  RegistrationFillProfileCollectionView.swift
//  XProject
//
//  Created by Максим Локтев on 18.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

class RegistrationFillProfileCollectionView: UICollectionView {
    
    private let layout = UICollectionViewFlowLayout()
    
    init() {
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        
        super.init(frame: .zero, collectionViewLayout: layout)
        
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
        isPagingEnabled = true
        bounces = false
        
        register(cellClass: RegistrationFillProfileNameCell.self)
        register(cellClass: RegistrationFillProfileGenderCell.self)
        register(cellClass: RegistrationFillProfileImageCell.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
