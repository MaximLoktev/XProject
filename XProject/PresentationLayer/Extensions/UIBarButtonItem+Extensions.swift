//
//  UIBarButtonItem+Extensions.swift
//  XProject
//
//  Created by Максим Локтев on 20.10.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    static func backBarButton(target: Any?, action: Selector) -> UIBarButtonItem {
        let barButton: UIBarButtonItem = makeBarButton(target: target, image: #imageLiteral(resourceName: "iconBack"), action: action)
        return barButton
    }
    
    static func saveBarButton(target: Any?, action: Selector) -> UIBarButtonItem {
        let barButton: UIBarButtonItem = makeBarButton(target: target, image: #imageLiteral(resourceName: "tick"), action: action)
        return barButton
    }
    
    private static func makeBarButton(target: Any?, image: UIImage?, action: Selector) -> UIBarButtonItem {
        let button: UIButton = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.addTarget(target, action: action, for: UIControl.Event.touchUpInside)

        let barButton = UIBarButtonItem(customView: button)
        let currWidth = barButton.customView?.widthAnchor.constraint(equalToConstant: 24)
        currWidth?.isActive = true
        let currHeight = barButton.customView?.heightAnchor.constraint(equalToConstant: 24)
        currHeight?.isActive = true
        
        return barButton
    }
}
