//
//  RegistrationFillProfileDataManager.swift
//  XProject
//
//  Created by Максим Локтев on 18.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

class RegistrationFillProfileDataManager: NSObject, UICollectionViewDataSource,
    UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   
    // MARK: - Properties
    
    var items: [RegistrationFillProfileDataFlow.Item] = []
    
    var currentPage = 0
    
    var onPageSelected: ((Int) -> Void)?
    
    var onImageTapped: (() -> Void)?
    
    var textFieldDidEditing: ((String) -> Void)?
    
    var genderDidSelected: ((Gender) -> Void)?

    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = items[indexPath.item]
        
        switch item.content {
        case .name(let username):
            let cell = collectionView.dequeueReusableCell(withClass: RegistrationFillProfileNameCell.self,
                                                          forIndexPath: indexPath)
            cell.setupCell(title: item.title, name: username)
            cell.textFieldDidEditing = textFieldDidEditing
  
            return cell
            
        case .gender(let gender):
            let cell = collectionView.dequeueReusableCell(withClass: RegistrationFillProfileGenderCell.self,
                                                          forIndexPath: indexPath)
            cell.setupCell(title: item.title, gender: gender)
            cell.genderDidSelected = genderDidSelected
            
            return cell
            
        case .image(let imageName):
            let cell = collectionView.dequeueReusableCell(withClass: RegistrationFillProfileImageCell.self,
                                                          forIndexPath: indexPath)
            cell.setupCell(title: item.title, imageName: imageName)
            cell.onImageTapped = onImageTapped
            
            return cell
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        collectionView.frame.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        onPageSelected?(currentPage)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x < scrollView.frame.width * CGFloat(currentPage) {
            scrollView.bounces = true
        } else {
            scrollView.contentOffset = CGPoint(x: scrollView.frame.width * CGFloat(currentPage), y: 0.0)
            scrollView.bounces = false
        }
    }
}
