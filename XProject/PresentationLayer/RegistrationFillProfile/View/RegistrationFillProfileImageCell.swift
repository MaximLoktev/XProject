//
//  RegistrationFillProfileImageCell.swift
//  XProject
//
//  Created by Максим Локтев on 18.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import SnapKit
import UIKit

class RegistrationFillProfileImageCell: RegistrationFillProfileCell {
    
    // MARK: - Properties
    
    var imageUrl: URL?
    
    let photoImageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 30
        image.contentMode = .scaleToFill
        
        return image
    }()
    
    var onImageTapped: (() -> Void)?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        
        let tapGesureRecognizer = UITapGestureRecognizer(target: self, action: #selector(photoTapGestureAction(_:)))
        photoImageView.isUserInteractionEnabled = true
        photoImageView.addGestureRecognizer(tapGesureRecognizer)
        
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setupCell(title: String, imageURL: URL?) {
        guard
            let imageUrl = imageURL,
            let imageData = try? Data(contentsOf: imageUrl)
        else {
            return
        }
        photoImageView.image = UIImage(data: imageData)
        titleLabel.text = title
    }
    
    // MARK: - Actions

    @objc
    private func photoTapGestureAction(_ sender: UITapGestureRecognizer) {
        onImageTapped?()
    }
    
    // MARK: - Layout
    
    private func makeConstraints() {
        photoImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(14.0)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(76.0)
        }
    }
}
