//
//  MyFeedInteractor.swift
//  XProject
//
//  Created by Максим Локтев on 27.09.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import FirebaseDatabase
import Foundation

internal protocol MyFeedBusinessLogic {
    func load(request: MyFeedDataFlow.Load.Request)
    func refresh(request: MyFeedDataFlow.Refresh.Request)
    func deletePost(request: MyFeedDataFlow.Delete.Request)
}

internal class MyFeedInteractor: MyFeedBusinessLogic {
    
    // MARK: - Properties

    var presenter: MyFeedPresentationLogic?
    
    private var ref: DatabaseReference = DatabaseReference()
    
    private let sessionManager: SessionManager
    
    private let newsFeedFirebaseService: NewsFeedFirebaseService
    
    private let profilleCoreDataService: ProfileCoreDataService
    
    // MARK: - Init
    
    init(profilleCoreDataService: ProfileCoreDataService,
         sessionManager: SessionManager) {
        self.profilleCoreDataService = profilleCoreDataService
        self.sessionManager = sessionManager
        self.newsFeedFirebaseService = NewsFeedFirebaseServiceImpl(databaseReference: ref,
                                                                   sessionManager: sessionManager)
    }
    
    // MARK: - MyFeedBusinessLogic
    
    func load(request: MyFeedDataFlow.Load.Request) {
        profilleCoreDataService.fetchUser(completion: { [weak self] result in
            guard let self = self else {
                return
            }
            var response: MyFeedDataFlow.Load.Response
            
            switch result {
            case .success(let user):
                self.newsFeedFirebaseService.fetchPostsFilter(key: .creatorId, value: user.userId) { result in
                    let response: MyFeedDataFlow.Load.Response
                    
                    switch result {
                    case .success(let postModel):
                        response = MyFeedDataFlow.Load.Response(result: .success(postModel))
                    case .failure(let error):
                        response = MyFeedDataFlow.Load.Response(result: .failure(error))
                    }
                    self.presenter?.presentLoad(response: response)
                }
            case .failure(let error):
                response = MyFeedDataFlow.Load.Response(result: .failure(error))
                self.presenter?.presentLoad(response: response)
            }
        })
    }
    
    func refresh(request: MyFeedDataFlow.Refresh.Request) {
        profilleCoreDataService.fetchUser(completion: { [weak self] result in
            guard let self = self else {
                return
            }
            var response: MyFeedDataFlow.Refresh.Response
            
            switch result {
            case .success(let user):
                self.newsFeedFirebaseService.fetchPostsFilter(key: .creatorId, value: user.userId) { result in
                    let response: MyFeedDataFlow.Refresh.Response
                    
                    switch result {
                    case .success(let postModel):
                        response = MyFeedDataFlow.Refresh.Response(result: .success(postModel))
                    case .failure(let error):
                        response = MyFeedDataFlow.Refresh.Response(result: .failure(error))
                    }
                    self.presenter?.presentRefresh(response: response)
                }
            case .failure(let error):
                response = MyFeedDataFlow.Refresh.Response(result: .failure(error))
                self.presenter?.presentRefresh(response: response)
            }
        })
    }
    
    func deletePost(request: MyFeedDataFlow.Delete.Request) {
        newsFeedFirebaseService.deletePost(key: request.post.id) { result in
            let response: MyFeedDataFlow.Delete.Response
            
            switch result {
            case .success:
                response = MyFeedDataFlow.Delete.Response(result: .success(()))
            case .failure(let error):
                response = MyFeedDataFlow.Delete.Response(result: .failure(.firebaseDeletePostError(error)))
            }
            
            self.presenter?.presentDeletePost(response: response)
        }
    }
}
