//
//  NewsFeetView.swift
//  XProject
//
//  Created by Максим Локтев on 02.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import AVFoundation
import SnapKit
import UIKit

internal protocol NewsFeetViewDelegate: class {

}

internal class NewsFeetView: UIView {

    // MARK: - Properties

    weak var delegate: NewsFeetViewDelegate?
    
    private let image: UIImageView = {
        let image = UIImageView()
        
        return image
    }()
    
    var player: AVAudioPlayer = {
        let audio = AVAudioPlayer()
        
        return audio
    }()
    
    private let onPlayerButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "fireIcon"), for: .normal)
        
        return button
    }()
    
    private let offPlayerButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "profilleIcon"), for: .normal)
        button.isHidden = true
        
        return button
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .blue
        
        addSubview(image)
        addSubview(onPlayerButton)
        addSubview(offPlayerButton)
        
        onPlayerButton.addTarget(self, action: #selector(onPlayerButtonAction(_:)), for: .touchUpInside)
        offPlayerButton.addTarget(self, action: #selector(offPlayerButtonAction(_:)), for: .touchUpInside)
        
        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARk: - Setup
    
    func setupImage(imageURL: String?) {
        guard let imageURL = imageURL else {
            return
        }
        image.kf.setImage(with: URL(string: imageURL), placeholder: #imageLiteral(resourceName: "profilleIcon"))
    }
    
    // MARK: - Actions
    
    @objc
    private func onPlayerButtonAction(_ sender: UIButton) {
        player.play()
        offPlayerButton.isHidden = false
        onPlayerButton.isHidden = true
    }
    
    @objc
    private func offPlayerButtonAction(_ sender: UIButton) {
        player.pause()
        offPlayerButton.isHidden = true
        onPlayerButton.isHidden = false
    }
    
    // MARK: - Layout
    
    private func makeConstraints() {
        image.snp.makeConstraints { make in
            make.height.width.equalTo(150.0)
            make.center.equalToSuperview()
        }
        onPlayerButton.snp.makeConstraints { make in
            make.height.equalTo(20.0)
            make.width.equalTo(20.0)
            make.right.equalToSuperview().offset(-10.0)
            make.top.equalToSuperview().offset(30.0)
        }
        offPlayerButton.snp.makeConstraints { make in
            make.height.equalTo(20.0)
            make.width.equalTo(20.0)
            make.right.equalToSuperview().offset(-10.0)
            make.top.equalToSuperview().offset(30.0)
        }
    }
    
}
