//
//  EditPostCollectionView.swift
//  XProject
//
//  Created by Максим Локтев on 20.11.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

class EditPostCollectionView: UICollectionView {
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.sectionInset = .zero
        
        super.init(frame: .zero, collectionViewLayout: layout)
        
        backgroundColor = .clear
        
        contentInset = UIEdgeInsets(top: 10.0, left: 16.0, bottom: 0.0, right: 16.0)
        showsHorizontalScrollIndicator = false
        alwaysBounceVertical = true
        
        register(cellClass: EditPostCell.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
