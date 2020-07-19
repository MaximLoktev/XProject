//
//  FillPersonalDataManager.swift
//  XProject
//
//  Created by Максим Локтев on 09.04.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

class FillPersonalDataManager: NSObject, UICollectionViewDataSource,
    UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   
    // MARK: - Properties
    
    var items: [FillPersonalDataFlow.PersonalData] = []
    
    var onPageSelected: ((Int, String) -> Void)?
    
    var onImageTapped: (() -> Void)?
    
    var currentPage = 0
    
    private var isFirstImageLoad = true
    
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
            let cell = collectionView.dequeueReusableCell(withClass: FillPersonalDataNameCell.self,
                                                          forIndexPath: indexPath)
            cell.setupCell(title: item.title, name: username)
  
            return cell
            
        case .gender(let gender):
            let cell = collectionView.dequeueReusableCell(withClass: FillPersonalDataGenderCell.self,
                                                          forIndexPath: indexPath)
            cell.setupCell(title: item.title, gender: gender)
            
            return cell
            
        case let .image(name, image):
            let cell = collectionView.dequeueReusableCell(withClass: FillPersonalDataImageCell.self,
                                                          forIndexPath: indexPath)
            var userImage: UIImage? = image
            if isFirstImageLoad {
                userImage = LetterImageGenerator.imageWith(name: name)
                isFirstImageLoad.toggle()
            }
            cell.setupCell(title: item.title, image: userImage)
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
        let currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        self.currentPage = currentPage
        let item = items[currentPage]
        
        onPageSelected?(currentPage, item.buttonTitle)
    }

    func setupNewPage() -> FillPersonalDataFlow.SetupNewPage {
        let isLastPage: Bool = self.currentPage < items.count - 1
        self.currentPage += 1
        
        if isLastPage {
            let item = items[currentPage]
            
            onPageSelected?(currentPage, item.buttonTitle)
        }
        
        let currentPageItem = currentPage - 1
        
        let setupNewPage = FillPersonalDataFlow.SetupNewPage(index: currentPage,
                                                             isLast: !isLastPage,
                                                             item: items[currentPageItem])
        return setupNewPage
    }
}
