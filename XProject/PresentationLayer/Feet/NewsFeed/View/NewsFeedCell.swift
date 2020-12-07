//
//  NewsFeedView.swift
//  XProject
//
//  Created by Максим Локтев on 27.09.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import SnapKit
import UIKit

internal class NewsFeedCell: UITableViewCell {

    // MARK: - Properties
    
    static func sizeFor(title: String, description: String) -> CGFloat {
        let widthCell = UIScreen.main.bounds.width
        let width = widthCell - 32 - 32
        
        let fontTitle = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        let fontDescription = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        
        let heightTitle = title.height(width: width, font: fontTitle)
        let heightDescription = description.height(width: width, font: fontDescription)
        
        let heightCell: CGFloat
        if description.isEmpty {
            heightCell = heightTitle + 133
        } else {
            heightCell = heightTitle + 133 + heightDescription
        }
        return heightCell
    }
    
    var onViewTapped: (() -> Void)?
    
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
    
    private let eventTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = .darkGrey50
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .black
        
        return label
    }()
    
    private let contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8.0
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let genderLabel: InsetLabel = {
        let label = InsetLabel()
        label.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
        label.textAlignment = .center
        label.textColor = .white
        label.layer.cornerRadius = 8.0
        label.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        label.clipsToBounds = true
        
        return label
    }()
    
    private let createdLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        label.text = "Создан"
        label.textColor = .darkGrey50
        
        return label
    }()
    
    private let photoProfile: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        imageView.layer.borderWidth = 2.0
        imageView.layer.cornerRadius = 16.0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let shadowPhoto: InputView = {
        let view = InputView()
        view.layer.cornerRadius = 16.0
        view.layer.applySketchShadow()
        
        return view
    }()
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .medium)
        label.textColor = .black
        
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
        cardView.addSubview(eventTimeLabel)
        
        cardView.addSubview(descriptionLabel)
        
        // Расстановка приоритетов контенту
        descriptionLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        descriptionLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        genderLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        genderLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        //cardView.addSubview(contentImageView)
        
        cardView.addSubview(genderLabel)
        
        cardView.addSubview(createdLabel)
        cardView.addSubview(shadowPhoto)
        shadowPhoto.addSubview(photoProfile)
        cardView.addSubview(fullNameLabel)
        cardView.addSubview(updateLabel)
        
        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setupCell(postModel: PostModel) {
        titleLabel.text = postModel.title.firstUppercased
        fullNameLabel.text = postModel.creatorName
        photoProfile.kf.setImage(with: URL(string: postModel.icon))
        descriptionLabel.text = postModel.description?.firstUppercased
        
        setupDate(eventDate: postModel.date, createDate: postModel.createDate)
        setupGenderLabel(text: postModel.gender)
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
    
    private func setupGenderLabel(text: String) {
        genderLabel.text = text
        
        switch text {
        case "iOS":
            genderLabel.backgroundColor = #colorLiteral(red: 0, green: 0.5098039216, blue: 0.9490196078, alpha: 1)
        case "Android":
            genderLabel.backgroundColor = #colorLiteral(red: 0.6481364965, green: 0.2536458969, blue: 0.05766300112, alpha: 1)
        default:
            genderLabel.backgroundColor = #colorLiteral(red: 0.1294117647, green: 0.6705882353, blue: 0, alpha: 1)
        }
    }
    
    // MARK: - Layout
    
    var heightDescriptionLabelConstraint: Constraint?
    
    private func makeConstraints() {
        cardView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8.0)
            make.left.right.equalToSuperview().inset(16.0)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16.0)
            make.left.right.equalToSuperview().inset(12.0)
        }
        eventTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8.0)
            make.left.equalToSuperview().offset(12.0)
            make.height.equalTo(15.0)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(eventTimeLabel.snp.bottom).offset(8.0)
            make.left.equalToSuperview().offset(12.0)
            make.right.equalTo(genderLabel.snp.left).offset(-12.0)
        }
        genderLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(32.0)
        }
        createdLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8.0)
            make.left.equalToSuperview().offset(12.0)
            make.width.equalTo(144.0)
            make.height.equalTo(15.0)
        }
        shadowPhoto.snp.makeConstraints { make in
            make.top.equalTo(createdLabel.snp.bottom).offset(8.0)
            make.left.bottom.equalToSuperview().inset(12.0)
            make.width.height.equalTo(32.0)
        }
        photoProfile.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        fullNameLabel.snp.makeConstraints { make in
            make.left.equalTo(shadowPhoto.snp.right).offset(12.0)
            make.centerY.equalTo(shadowPhoto.snp.centerY)
            make.height.equalTo(16.0)
        }
        updateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(shadowPhoto.snp.centerY)
            make.right.equalToSuperview().offset(-12.0)
            make.left.equalTo(fullNameLabel.snp.right).offset(12.0)
            make.height.equalTo(15.0)
            make.width.equalTo(120.0)
        }
    }
}
