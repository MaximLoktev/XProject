//
//  AppDependency.swift
//  XProject
//
//  Created by Максим Локтев on 01.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import Foundation

protocol RootDependency {
    var sessionManager: SessionManager { get }
    var fileDataStorageService: FileDataStorageService { get }
    
    var registrationFillProfileBuilder: RegistrationFillProfileBuildable { get }
}

class AppDependency: RootDependency {
    
    private(set) lazy var sessionManager: SessionManager = InMemorySessionStorage()
    
    private(set) lazy var fileDataStorageService: FileDataStorageService = FileDataStorage()
    
    // MARK: - Builders
    
    private(set) lazy var registrationFillProfileBuilder: RegistrationFillProfileBuildable =
        RegistrationFillProfileBuilder(fileDataStorageService: fileDataStorageService)
}
