//
//  AppDependency.swift
//  XProject
//
//  Created by Максим Локтев on 01.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import FirebaseDatabase

protocol RootDependency {
    var sessionManager: SessionManager { get }
    var fileDataStorageService: FileDataStorageService { get }
    var coreData: CoreData { get }
    var profileCoreDataService: ProfileCoreDataService { get }
    
    var databaseReference: DatabaseReference { get }
    var profileFirebaseService: ProfileFirebaseService { get }
    var newFeedFirebaseService: NewsFeedFirebaseService { get }
    
    var imageService: ImageService { get }
}

class AppDependency: RootDependency {
    
    private(set) lazy var sessionManager: SessionManager = InMemorySessionStorage()
    
    private(set) lazy var fileDataStorageService: FileDataStorageService = FileDataStorage()
    
    private(set) lazy var coreData = CoreData()
    
    private(set) lazy var profileCoreDataService: ProfileCoreDataService = ProfilleCoreDataServiceImpl(
        coreData: coreData
    )
    
    private(set) lazy var databaseReference: DatabaseReference = DatabaseReference()
    
    private(set) lazy var imageService: ImageService = ImageServiceImpl()
    
    private(set) lazy var profileFirebaseService: ProfileFirebaseService = ProfileFirebaseServiceImpl(
        databaseReference: databaseReference,
        sessionManager: sessionManager
    )
    
    private(set) lazy var newFeedFirebaseService: NewsFeedFirebaseService = NewsFeedFirebaseServiceImpl(
        databaseReference: databaseReference,
        sessionManager: sessionManager
    )
}
