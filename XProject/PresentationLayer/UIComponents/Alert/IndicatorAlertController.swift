//
//  IndicatorAlertController.swift
//  XProject
//
//  Created by Максим Локтев on 08.09.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import Lottie
import UIKit

final class IndicatorAlertController: UIViewController {
    
    // MARK: - Properties
    
    private let indicatorWindow: UIWindow
    
    private static let shared: IndicatorAlertController = IndicatorAlertController()
    
    private var propertyAnimator: UIViewPropertyAnimator?
    
    private let duration: TimeInterval = 0.3
    
    private let circleIndicator: LoadingIndicator = {
        let indicator = LoadingIndicator()
        indicator.alpha = 0.0
        
        return indicator
    }()
    
    // MARK: - Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        indicatorWindow = UIWindow(frame: UIScreen.main.bounds)
        indicatorWindow.windowLevel = UIWindow.Level.statusBar - 0.1
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        view.addSubview(circleIndicator)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // return keyboard events to app main window
        UIApplication.shared.delegate?.window??.makeKey()
    }
    
    static func show() {
        shared.showIndicator()
    }
    
    private func showIndicator() {
        indicatorWindow.rootViewController = self
        indicatorWindow.makeKeyAndVisible()
        
        setupPresentAnimation()
        propertyAnimator?.startAnimation()
    }
    
    static func hide() {
        shared.hideIndicator()
    }
    
    private func hideIndicator() {
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
            self.setupDismissAnimation()
            self.propertyAnimator?.startAnimation()
        }
    }
    
    // MARK: - Setup
    
    private func setupPresentAnimation() {
        propertyAnimator = UIViewPropertyAnimator(
            duration: duration,
            curve: .easeInOut,
            animations: {
                self.circleIndicator.alpha = 1.0
                self.view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
                self.circleIndicator.startAnimation()
            }
        )
    }
    
    private func setupDismissAnimation() {
        propertyAnimator = UIViewPropertyAnimator(
            duration: duration,
            curve: .easeInOut,
            animations: {
                self.circleIndicator.alpha = 0.0
                self.view.backgroundColor = .clear
            }
        )
        propertyAnimator?.addCompletion { _ in
            self.indicatorWindow.isHidden = true
            self.circleIndicator.stopAnimation()
        }
    }
    
    // MARK: - Layout
    
    func makeConstraints() {
        circleIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(150.0)
        }
    }
}
