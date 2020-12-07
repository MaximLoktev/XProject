//
//  UIToolBar + Extensions.swift
//  XProject
//
//  Created by Максим Локтев on 07.11.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

extension UIToolbar {

    static func simple() -> Self {
        let toolbar = self.init(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 50.0))
        toolbar.isTranslucent = false
        //toolbar.barTintColor = .white
        //toolbar.tintColor = .da

        return toolbar
    }
}
