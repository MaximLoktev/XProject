//
//  ProfilleViewController.swift
//  XProject
//
//  Created by Максим Локтев on 03.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

internal protocol ProfilleModuleOutput: class {

}

internal protocol ProfilleModuleInput: class {

}

internal class ProfilleViewController: UIViewController, ProfilleModuleInput, ProfilleViewDelegate {

    // MARK: - Properties

    weak var moduleOutput: ProfilleModuleOutput?

    var moduleView: ProfilleView!

    // MARK: - View life cycle

    override func loadView() {
        moduleView = ProfilleView(frame: UIScreen.main.bounds)
        moduleView.delegate = self
        view = moduleView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - ProfilleViewDelegate
    
}
