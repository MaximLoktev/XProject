//
//  FillPersonalDataView.swift
//  XProject
//
//  Created by Максим Локтев on 08.04.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import SnapKit
import UIKit

protocol FillPersonalDataViewDelegate: class {
    func viewDidTapNextButton(_ view: FillPersonalDataView)
}

class FillPersonalDataView: UIView {

    // MARK: - Properties

    weak var delegate: FillPersonalDataViewDelegate?
    
    private let collectionView = FillPersonalDataCollectionView()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "background")
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 50.0, weight: .medium)
        label.text = "XProject"
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20.0
        
        return view
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton.shadowButton()
        button.setTitle("Далее", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    private let pageControll: UIPageControl = {
        let page = UIPageControl()
        page.currentPage = 0
        page.numberOfPages = 3
        page.pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.1)
        page.currentPageIndicatorTintColor = .gray
        page.isUserInteractionEnabled = false
        page.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        
        return page
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backgroundImageView)
        addSubview(titleLabel)
        addSubview(cardView)
        cardView.addSubview(collectionView)
        cardView.addSubview(nextButton)
        cardView.addSubview(pageControll)
        
        nextButton.addTarget(self, action: #selector(nextButtonAction(_:)), for: .touchUpInside)
        
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setupDataManager(dataManager: UICollectionViewDataSource & UICollectionViewDelegate) {
        collectionView.delegate = dataManager
        collectionView.dataSource = dataManager
        collectionView.reloadData()
    }
    
    func setupPage(with page: Int, title: String) {
        pageControll.currentPage = page
        nextButton.setTitle(title, for: .normal)
    }
    
    func setupNewPage(page: Int) {
        collectionView.scrollToItem(at: IndexPath(item: page, section: 0), at: .right, animated: true)
    }
    
    // MARK: - Actions
    
    @objc
    private func nextButtonAction(_ sender: UIButton) {
        delegate?.viewDidTapNextButton(self)
    }
    
    // MARK: - Layout
    
    var topTitleLabelConstraint: Constraint?
    var topCarViewConstraint: Constraint?
    
    private func makeConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            topTitleLabelConstraint = make.top.equalTo(snp.bottom).multipliedBy(0.25).constraint
            make.left.right.equalToSuperview().inset(16.0)
        }
        cardView.snp.makeConstraints { make in
            topCarViewConstraint = make.bottom.equalToSuperview().offset(-32.0).constraint
            make.height.equalTo(224.0)
            make.left.right.equalToSuperview().inset(32.0)
        }
        collectionView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top).offset(-10.0)
        }
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(44.0)
            make.bottom.equalTo(pageControll.snp.top)
            make.left.right.equalToSuperview().inset(20.0)
        }
        pageControll.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20.0)
            make.bottom.equalToSuperview()
        }
    }
}
