//
//  AlertWindowController.swift
//  XProject
//
//  Created by Максим Локтев on 14.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

class AlertWindowController: UIAlertController {

    // MARK: - Properties

    private let alertWindow: UIWindow
    
    // MARK: - Init

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.windowLevel = UIWindow.Level.statusBar - 0.1
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle

    func show(animated: Bool = true) {
        let viewController = UIViewController()

        alertWindow.rootViewController = viewController
        alertWindow.makeKeyAndVisible()

        if let tintColor = UIApplication.shared.delegate?.window??.tintColor {
            alertWindow.tintColor = tintColor
        }
        
        viewController.present(self, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // return keyboard events to app main window
        UIApplication.shared.delegate?.window??.makeKey()
    }
}
