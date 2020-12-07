//
//  MyFeedView.swift
//  XProject
//
//  Created by Максим Локтев on 27.09.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import SnapKit
import UIKit

internal protocol MyFeedViewDelegate: class {
    func refreshNewsFeed()
}

internal class MyFeedView: UIView {

    // MARK: - Properties

    weak var delegate: MyFeedViewDelegate?
    
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(cellClass: MyFeedCell.self)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        
        return tableView
    }()
    
    private let placeholder: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .regular)
        label.textAlignment = .center
        label.text = "У Вас ещё нет постов"
        label.textColor = .darkGrey50
        label.isHidden = true
        
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(tableView)
        tableView.addSubview(placeholder)
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(pulledToRefresh), for: .valueChanged)
    
        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setupLoad(viewModel: MyFeedDataFlow.Load.ViewModel) {
        
    }
    
    func setupDataManager(dataManager: UITableViewDelegate & UITableViewDataSource) {
        tableView.delegate = dataManager
        tableView.dataSource = dataManager
        tableView.reloadData()
    }
    
    func setupPlaceholder(isPlaceholderShow: Bool) {
        placeholder.isHidden = !isPlaceholderShow
    }
    
    // MARK: - Action
    
    @objc
    func pulledToRefresh() {
        delegate?.refreshNewsFeed()
        tableView.reloadData()
        
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }

    // MARK: - Layout
    
    private func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        placeholder.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(23.0)
        }
    }
}
