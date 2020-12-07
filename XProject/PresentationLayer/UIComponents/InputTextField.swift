//
//  InputTextField.swift
//  XProject
//
//  Created by Максим Локтев on 29.10.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

class InputTextField: InsetTextField {
    
    // MARK: - Properties
    
    private let containerView: InputView = InputView()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        font = .systemFont(ofSize: 17.0)
        textColor = .darkGray
        clearButtonMode = .always
        autocorrectionType = .no
        
        containerView.isUserInteractionEnabled = false
        insertSubview(containerView, at: 0)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func makeConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
