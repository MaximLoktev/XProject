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
   
    struct PersonalData {
        let title: String
        let content: Content
        let buttonTitle: String
    }

    enum Content {
        case name
        case gender
        case image(data: Data)
    }
    
    // MARK: - Properties
    
    var items: [PersonalData] = [
        PersonalData(title: "Давай знакомиться.\nКак тебя зовут?", content: .name, buttonTitle: "Далее"),
        PersonalData(title: "Ваш пол", content: .gender, buttonTitle: "Далее"),
        PersonalData(title: "Фото", content: .image(data: #imageLiteral(resourceName: "pera").jpegData(compressionQuality: 1.0)!), buttonTitle: "Начать")
    ]
    
    var onPageSelected: ((Int, String) -> Void)?
    
    private var currentPage = 0
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = items[indexPath.item]
        
        switch item.content {
        case .name:
            let cell = collectionView.dequeueReusableCell(withClass: FillPersonalDataNameCell.self,
                                                          forIndexPath: indexPath)
            cell.setupCell(title: item.title)
            
            return cell
            
        case .gender:
            let cell = collectionView.dequeueReusableCell(withClass: FillPersonalDataGenderCell.self,
                                                          forIndexPath: indexPath)
            cell.setupCell(title: item.title)
            
            return cell
            
        case .image(let imageData):
            let cell = collectionView.dequeueReusableCell(withClass: FillPersonalDataImageCell.self,
                                                          forIndexPath: indexPath)
            cell.setupCell(title: item.title, image: imageData)
            
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

    func setupNewPage() -> (index: Int, isLast: Bool) {
        let isLastPage: Bool = self.currentPage < items.count - 1
        if isLastPage {
            self.currentPage += 1
            let item = items[currentPage]
            
            onPageSelected?(currentPage, item.buttonTitle)
        }

        return (index: currentPage, isLast: !isLastPage)
    }
}
