//
//  ProfileDataCell.swift
//  XProject
//
//  Created by Максим Локтев on 15.09.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import SnapKit
import UIKit

internal class ProfileDataCell: UITableViewCell {
    
    // MARK: - Properties
    
    private let divisionView: DivisionView = DivisionView()
    
    private let titleLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = UIColor.gray.withAlphaComponent(1.0)
        label.backgroundColor = .clear

        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        label.textColor = .black
        label.backgroundColor = .clear

        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        addSubview(titleLable)
        addSubview(descriptionLabel)
        addSubview(divisionView)
        
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setupCell(title: String, description: String, divisionForm: DivisionForm) {
        titleLable.text = title
        descriptionLabel.text = description
        divisionView.divisionForm = divisionForm

    }
    
    // MARK: - Layout
    
    private func makeConstraints() {
        divisionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(16.0)
            make.width.equalTo(13.0)
            make.bottom.equalToSuperview()
        }
        titleLable.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10.0)
            make.right.equalToSuperview()
            make.left.equalTo(divisionView.snp.right).offset(32.0)
            make.height.equalTo(15.0)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLable.snp.bottom).offset(4.0)
            make.right.equalToSuperview()
            make.left.equalTo(divisionView.snp.right).offset(32.0)
            make.height.equalTo(20.0)
        }
    }
}
