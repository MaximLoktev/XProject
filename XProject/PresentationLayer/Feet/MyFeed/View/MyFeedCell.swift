//
//  MyFeedCell.swift
//  XProject
//
//  Created by Максим Локтев on 11.11.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import SnapKit
import UIKit

internal class MyFeedCell: UITableViewCell {

    // MARK: - Properties
    
    static func sizeFor(title: String) -> CGFloat {
        let widthCell = UIScreen.main.bounds.width
        let width = widthCell - 32 - 32
        let font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        let height = title.height(width: width, font: font)
        let heightCell = height + 80
        
        return heightCell
    }
    
    var postModel: PostModel?
    
    var onEditPostDidTapped: ((PostModel) -> Void)?
    
    var onDeletePostDidTapped: ((PostModel) -> Void)?
    
    private let cardView: InputView = {
        let cardView = InputView()
        cardView.layer.cornerRadius = 16.0
        cardView.layer.applySketchShadow(color: .sexyBlack,
                                         alpha: 0.3,
                                         x: 0.0,
                                         y: 4.0,
                                         blur: 8.0,
                                         spread: 0.0)
        
        return cardView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        label.numberOfLines = 2
        label.textColor = .black
        
        return label
    }()
    
    private let editPostButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "edit1483"), for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "edit1483").withTintColor(.gray, renderingMode: .alwaysOriginal), for: .highlighted)
        
        return button
    }()
    
    private let deletePostButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "delete"), for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "delete").withTintColor(.gray, renderingMode: .alwaysOriginal), for: .highlighted)
        
        return button
    }()
    
    private let eventTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = .darkGrey50
        
        return label
    }()
    
    private let updateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        label.textAlignment = .right
        label.textColor = .darkGrey50
        
        return label
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
     
        backgroundColor = .clear
        
        contentView.addSubview(cardView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(editPostButton)
        cardView.addSubview(deletePostButton)
        cardView.addSubview(eventTimeLabel)
        cardView.addSubview(updateLabel)
        
        editPostButton.addTarget(self, action: #selector(nextButtonAction(_:)), for: .touchUpInside)
        deletePostButton.addTarget(self, action: #selector(deleteButtonAction(_:)), for: .touchUpInside)
        
        // Расстановка приоритетов контенту
//        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
//        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//        genderLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//        genderLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setupCell(postModel: PostModel) {
        self.postModel = postModel
        titleLabel.text = postModel.title.firstUppercased
        setupDate(eventDate: postModel.date, createDate: postModel.createDate)
    }
    
    private func setupDate(eventDate: Int, createDate: Int) {
        let date = Date()
        let createDate = Date(timeIntervalSince1970: TimeInterval(createDate))
        let eventDate = Date(timeIntervalSince1970: TimeInterval(eventDate))
        
        updateLabel.text = date.offset(from: createDate)
        eventTimeLabel.text = setupDateFormated(date: eventDate)
    }
    
    private func setupDateFormated(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy HH:mm"
        formatter.locale = Locale(identifier: "ru_RU")
        let dateFormat = formatter.string(from: date)
        
        return dateFormat
    }
    
    // MARK: - Actions
    
    @objc
    func nextButtonAction(_ sender: UIButton) {
        guard let post = postModel else {
            return
        }
        onEditPostDidTapped?(post)
    }
    
    @objc
    func deleteButtonAction(_ sender: UIButton) {
        guard let post = postModel else {
            return
        }
        onDeletePostDidTapped?(post)
    }
    
    // MARK: - Layout
    
    private func makeConstraints() {
        cardView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8.0)
            make.left.right.equalToSuperview().inset(16.0)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16.0)
            make.left.equalToSuperview().offset(12.0)
            make.right.equalTo(editPostButton.snp.left).offset(-16.0)
        }
        editPostButton.snp.makeConstraints { make in
            make.height.width.equalTo(24.0)
            make.top.equalToSuperview().inset(16.0)
            make.right.equalTo(deletePostButton.snp.left).offset(-18.0)
        }
        deletePostButton.snp.makeConstraints { make in
            make.height.equalTo(24.0)
            make.width.equalTo(20.0)
            make.top.equalToSuperview().offset(15.0)
            make.right.equalToSuperview().offset(-10.0)
        }
        eventTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16.0)
            make.left.equalToSuperview().offset(12.0)
            make.height.equalTo(15.0)
        }
        updateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16.0)
            make.right.equalToSuperview().offset(-12.0)
            make.height.equalTo(15.0)
        }
    }
}
