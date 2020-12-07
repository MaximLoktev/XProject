//
//  CreatePostCell.swift
//  XProject
//
//  Created by Максим Локтев on 28.10.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import SnapKit
import UIKit

internal class CreatePostCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var onImageTapped: (() -> Void)?
    
    var onImageDelete: ((UIImage) -> Void)?
    
    private let contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8.0
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let deletePhotoButton: UIButton = {
        let button = AdjustedTapAreaButton()
        button.setImage(#imageLiteral(resourceName: "cancelIcon"), for: .normal)
        button.backgroundColor = .darkSkyBlue
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 10.0
            
        return button
    }()
    
    private let shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = nil
        layer.strokeColor = UIColor.darkGrey50.cgColor
        layer.lineWidth = 1.0
        layer.lineJoin = CAShapeLayerLineJoin.round
        layer.lineDashPattern = [8, 10]
        
        return layer
    }()
    
    private let shapeLayerFill: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.borderColor = UIColor.darkSkyBlue.cgColor
        layer.cornerRadius = 8.0
        layer.borderWidth = 2
        
        return layer
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addSubview(contentImageView)
        let tapGesureRecognizer = UITapGestureRecognizer(target: self, action: #selector(photoTapGestureAction))
        contentImageView.isUserInteractionEnabled = true
        contentImageView.addGestureRecognizer(tapGesureRecognizer)
        
        layer.addSublayer(shapeLayerFill)
        
        addSubview(deletePhotoButton)
        deletePhotoButton.addTarget(self, action: #selector(deletePhotoAction), for: .touchUpInside)
        
        layer.addSublayer(shapeLayer)
        
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        shapeLayerFill.bounds = bounds
        shapeLayerFill.position = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        
        shapeLayer.bounds = bounds
        shapeLayer.position = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        shapeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 8.0).cgPath
    }
    
    // MARK: - Setup
    
    func setupCell(state: CreatePostDataFlow.State, image: UIImage) {
        switch state {
        case .fill:
            shapeLayer.isHidden = true
            shapeLayerFill.isHidden = false
            deletePhotoButton.isHidden = false
            contentImageView.isUserInteractionEnabled = false
        case .active:
            shapeLayer.isHidden = false
            shapeLayerFill.isHidden = true
            deletePhotoButton.isHidden = true
            contentImageView.isUserInteractionEnabled = true
        case .empty:
            shapeLayer.isHidden = false
            shapeLayerFill.isHidden = true
            deletePhotoButton.isHidden = true
            contentImageView.isUserInteractionEnabled = false
        }
        contentImageView.image = image
        layoutIfNeeded()
    }
    
    // MARK: - Actions
    
    @objc
    func photoTapGestureAction() {
        onImageTapped?()
    }
    
    @objc
    func deletePhotoAction() {
        guard let image = contentImageView.image else {
            return
        }
        onImageDelete?(image)
    }
    
    // MARK: - Layout
    
    private func makeConstraints() {
        contentImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        deletePhotoButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-7.0)
            make.right.equalToSuperview().offset(7.0)
            make.height.width.equalTo(20.0)
        }
    }
}
