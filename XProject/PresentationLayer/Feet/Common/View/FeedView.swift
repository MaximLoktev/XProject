//
//  FeetView.swift
//  XProject
//
//  Created by Максим Локтев on 02.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import AVFoundation
import Segmentio
import SnapKit
import UIKit

internal protocol FeedViewDelegate: class {
    func viewDidNextPageController(index: Int)
}

internal class FeedView: UIView {

    enum Constants {
        static let items: [SegmentioItem] = [
            SegmentioItem(title: "Новости", image: nil),
            SegmentioItem(title: "Мои посты", image: nil)
        ]
    }
    
    // MARK: - Properties

    weak var delegate: FeedViewDelegate?
    
    private let pageView: UIView
    
    private var segmentioView: Segmentio = Segmentio()
    
    private let segmentedControl = CBSegmentedControl()

    // MARK: - Init

    init(frame: CGRect, pageView: UIView) {
        self.pageView = pageView
        super.init(frame: frame)
        
        segmentioView.selectedSegmentioIndex = 0
        
        backgroundColor = .white
        addSubview(segmentioView)
        addSubview(pageView)
        
        setupSegmentioView()
        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setupSegmentControl(index: Int) {
        segmentioView.selectedSegmentioIndex = index
    }
    
    private func setupSegmentioView() {
        segmentioView.valueDidChange = { [weak self] segmentio, segmentIndex in
            if segmentio == self?.segmentioView {
                self?.delegate?.viewDidNextPageController(index: segmentIndex)
            }
        }
        segmentioView.setup(content: Constants.items,
                            style: .imageOverLabel,
                            options: segmentedControl.options)
    }
    
    // MARK: - Layout
    
    private func makeConstraints() {
        segmentioView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(46.0)
            make.width.equalTo(bounds.size.width)
        }
        pageView.snp.makeConstraints { make in
            make.top.equalTo(segmentioView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
