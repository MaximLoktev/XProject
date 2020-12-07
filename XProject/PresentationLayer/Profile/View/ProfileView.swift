//
//  ProfileView.swift
//  XProject
//
//  Created by Максим Локтев on 03.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import SnapKit
import UIKit

internal protocol ProfileViewDelegate: class {
    func viewDidTapNextButton()
}

internal class ProfileView: UIView {

    // MARK: - Properties

    weak var delegate: ProfileViewDelegate?
    
    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint(x: 1, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        layer.colors = [UIColor.bluegrey.cgColor, UIColor.peacockBlue.cgColor]
        
        return layer
    }()
    
    private let contentView: InputView = {
        let view = InputView()
        view.layer.cornerRadius = 18.0
        
        return view
    }()
    
    private let photoProfile: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        imageView.layer.borderWidth = 4.0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let shadowPhoto: InputView = {
        let view = InputView()
        
        return view
    }()
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "edit1483"), for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "edit1483").withTintColor(.gray, renderingMode: .alwaysOriginal), for: .highlighted)
        
        return button
    }()
    
    private let countPostLabel: UILabel = {
        let label = UILabel()
        label.text = "Кол-во постов: 23"
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        
        return label
    }()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "#abbcccddddeeeeee"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22.0, weight: .semibold)
        
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = false
        tableView.bounces = false
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(cellClass: ProfileDataCell.self)
        
        return tableView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.addSublayer(gradientLayer)
        
        addSubview(contentView)
        contentView.addSubview(shadowPhoto)
        shadowPhoto.addSubview(photoProfile)
        contentView.addSubview(editButton)
        contentView.addSubview(countPostLabel)
        contentView.addSubview(loginLabel)
        contentView.addSubview(tableView)
        
        editButton.addTarget(self, action: #selector(nextButtonAction(_:)), for: .touchUpInside)
        
        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowPhoto.layer.cornerRadius = frame.size.width * 0.45 / 2.0
        shadowPhoto.layer.applySketchShadow()
        photoProfile.layer.cornerRadius = frame.size.width * 0.45 / 2.0
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height / 3)
    }
    
    // MARK: - Setup
    
    func setupDataManager(dataManager: UITableViewDataSource & UITableViewDelegate) {
        tableView.delegate = dataManager
        tableView.dataSource = dataManager
        tableView.reloadData()
    }
    
    func setupPhotoImage(image: String) {
        photoProfile.kf.setImage(with: URL(string: image))
    }
    
    // MARK: - Actions
    
    @objc
    func nextButtonAction(_ sender: UIButton) {
        delegate?.viewDidTapNextButton()
    }
    
    // MARK: - Layout
    
    var photoProfileCornerRadius: Constraint?
    
    private func makeConstraints() {
        contentView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12.0)
            make.top.equalTo(self.bounds.size.height * 0.25)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-16.0)
        }
        shadowPhoto.snp.makeConstraints { make in
            make.height.width.equalTo(snp.width).multipliedBy(0.45)
            make.centerY.equalTo(contentView.snp.top)
            make.centerX.equalToSuperview()
        }
        photoProfile.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        editButton.snp.makeConstraints { make in
            make.height.width.equalTo(30.0)
            make.top.equalToSuperview().offset(20.0)
            make.right.equalToSuperview().offset(-28.0)
        }
        countPostLabel.snp.makeConstraints { make in
            make.top.equalTo(photoProfile.snp.bottom).offset(12.0)
            make.centerX.equalToSuperview()
            make.height.equalTo(15.0)
        }
        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(countPostLabel.snp.bottom).offset(2.0)
            make.centerX.equalToSuperview()
            make.height.equalTo(25.0)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(loginLabel.snp.bottom).offset(27.0)
            make.bottom.equalToSuperview().offset(-8.0)
            make.left.right.equalToSuperview().inset(16.0)
        }
    }
}
