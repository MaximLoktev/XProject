//
//  TitleTextPicker.swift
//  XProject
//
//  Created by Максим Локтев on 26.10.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import SnapKit
import UIKit

internal class TitleTextPicker: UIView {
    
    // MARK: - Properies
    
    var genderPicker: GenderPickerView {
        genderTextPicker
    }
    
    var warningIsHidden: Bool {
        get {
            warningTitleLabel.isHidden
        }
        set {
            warningTitleLabel.isHidden = newValue
        }
    }
    
    var warningText: String? {
        get {
            warningTitleLabel.text
        }
        set {
            warningTitleLabel.text = newValue
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textColor = .darkGrey50
        
        return label
    }()
    
    private let containerView: InputView = InputView()
    
    private let genderTextPicker: GenderPickerView = {
        let picker = GenderPickerView()
        picker.selectRow(0, inComponent: 0, animated: true)
        
        return picker
    }()
    
    private let warningTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = .systemFont(ofSize: 13.0)
        label.isHidden = true
        
        return label
    }()
    
    // MARK: - Init
    
    init(title: String, warning: String) {
        super.init(frame: .zero)
        
        titleLabel.text = title
        warningTitleLabel.text = warning
    
        addSubview(titleLabel)
        addSubview(containerView)
        containerView.addSubview(genderTextPicker)
        addSubview(warningTitleLabel)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }
    
    // MARK: - Layout
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(15.0)
        }
        containerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8.0)
            make.left.right.equalToSuperview()
            make.height.equalTo(128.0)
        }
        genderTextPicker.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        warningTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(4.0)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(15.0)
        }
    }
}
