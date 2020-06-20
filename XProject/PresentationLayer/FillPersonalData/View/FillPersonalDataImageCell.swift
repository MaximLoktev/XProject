//
//  FillPersonalDataImageCell.swift
//  XProject
//
//  Created by Максим Локтев on 10.04.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import SnapKit
import UIKit

class FillPersonalDataImageCell: FillPersonalDataCell {
    
    // MARK: - Properties
    
    let photoImageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 30
        image.contentMode = .scaleToFill
        
        return image
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setupCell(title: String, image: Data) {
        photoImageView.image = LetterImageGenerator.imageWith(name: title)
        titleLabel.text = title
        //photoImageView.image = UIImage(data: image)
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
