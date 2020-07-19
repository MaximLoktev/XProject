//
//  ProfilleView.swift
//  XProject
//
//  Created by Максим Локтев on 03.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

internal protocol ProfilleViewDelegate: class {

}

internal class ProfilleView: UIView {

    // MARK: - Properties

    weak var delegate: ProfilleViewDelegate?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .red
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
