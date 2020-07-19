//
//  AppDelegate.swift
//  XProject
//
//  Created by Максим Локтев on 04.04.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import CoreData
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private let appDependency: RootDependency = AppDependency()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let rootViewController = RootViewController(appDependency: appDependency)
        let window = UIWindow()
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
        self.window = window
        
        return true
    }

}
