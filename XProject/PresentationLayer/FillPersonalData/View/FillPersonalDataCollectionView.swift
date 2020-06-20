//
//  FillPersonalDataCollectionView.swift
//  XProject
//
//  Created by Максим Локтев on 09.04.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

class FillPersonalDataCollectionView: UICollectionView {
    
    private let layout = UICollectionViewFlowLayout()
    
    init() {
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        
        super.init(frame: .zero, collectionViewLayout: layout)
        
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
        isPagingEnabled = true
        bounces = false
        
        register(cellClass: FillPersonalDataNameCell.self)
        register(cellClass: FillPersonalDataGenderCell.self)
        register(cellClass: FillPersonalDataImageCell.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
