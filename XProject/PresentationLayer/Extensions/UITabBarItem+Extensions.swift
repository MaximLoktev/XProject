//
//  UITabBarItem+Extensions.swift
//  XProject
//
//  Created by Максим Локтев on 03.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

extension UITabBarItem {
    
    static func simpleIconItem(image: UIImage, tag: Int) -> UITabBarItem {
        let tabBarItem = UITabBarItem(title: nil, image: image, tag: tag)
        tabBarItem.imageInsets = UIEdgeInsets(top: 12.0, left: 0.0, bottom: 2.0, right: 0.0)
        return tabBarItem
    }
    
}
