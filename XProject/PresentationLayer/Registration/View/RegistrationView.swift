//
//  RegistrationView.swift
//  XProject
//
//  Created by Максим Локтев on 04.04.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import AuthenticationServices
import Lottie
import SnapKit
import UIKit

internal protocol RegistrationViewDelegate: class {

}

internal class RegistrationView: UIView {

    // MARK: - Properties

    weak var delegate: RegistrationViewDelegate?
    
    private let animationView: AnimationView = AnimationView()

    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "background")
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32.0, weight: .medium)
        label.text = "New meetup (p)era"
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
    
    private let cardTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 50.0, weight: .medium)
        label.text = "XProject"
        label.textColor = .sexyBlack
        label.textAlignment = .center
        
        return label
    }()
    
    private let cardDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
        label.text = "corporated"
        label.textColor = .darkGrey50
        
        return label
    }()
    
    private let peraImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "pera")
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let authButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton()
        button.addTarget(self, action: #selector(authButtonAction), for: .touchUpInside)
        button.cornerRadius = 12.0
        
        return button
    }()
    
    private let authorizationController: ASAuthorizationController = {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
        return authorizationController
    }()
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backgroundImageView)
        addSubview(titleLabel)
        addSubview(cardView)
        cardView.addSubview(cardTitleLabel)
        cardView.addSubview(cardDescriptionLabel)
        cardView.addSubview(peraImageView)
        cardView.addSubview(authButton)
        
        setupAnimation()
        
        makeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setupAuthorization(dataManager: ASAuthorizationControllerPresentationContextProviding &
        ASAuthorizationControllerDelegate) {
        authorizationController.delegate = dataManager
        authorizationController.presentationContextProvider = dataManager
    }
    
    private func setupAnimation() {
        animationView.animation = Animation.named("fireworks")
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.8
        animationView.play()
        addSubview(animationView)
    }
    
    // MARK: - Actions
    
    @objc
    private func authButtonAction() {
        authorizationController.performRequests()
    }
    
    // MARK: - Layout
    
    private func makeConstraints() {
        animationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(snp.bottom).multipliedBy(0.3)
            make.left.right.equalToSuperview().inset(16.0)
        }
        cardView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(32.0)
        }
        cardTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24.0)
            make.centerX.equalToSuperview()
        }
        cardDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(cardTitleLabel.snp.bottom).offset(-8.0)
            make.left.right.equalTo(cardTitleLabel)
        }
        peraImageView.snp.makeConstraints { make in
            make.height.equalTo(98.0)
            make.width.equalTo(81.0)
            make.bottom.equalTo(authButton.snp.bottom)
            make.right.equalToSuperview().offset(-12.0)
        }
        authButton.snp.makeConstraints { make in
            make.height.equalTo(44.0)
            make.top.equalTo(cardDescriptionLabel.snp.bottom).offset(36.0)
            make.left.right.bottom.equalToSuperview().inset(20.0)
        }
    }
    
}
