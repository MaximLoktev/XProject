//
//  EditPostDataManager.swift
//  XProject
//
//  Created by Максим Локтев on 20.11.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

internal class EditPostDataManager: NSObject, UICollectionViewDataSource,
                                      UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    var items: [EditPostDataFlow.Item] = []
    
    var onImageTapped: (() -> Void)?
    
    var onImageDelete: ((UIImage) -> Void)?
    
    private let widthCell: CGFloat = (UIScreen.main.bounds.width - 64.0) / 3.0
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = items[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withClass: EditPostCell.self, forIndexPath: indexPath)
        cell.setupCell(state: item.state, image: item.image)
        cell.onImageTapped = onImageTapped
        cell.onImageDelete = onImageDelete
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = EditPostView.Constants.cellSize
        return CGSize(width: width, height: width)
    }
}
