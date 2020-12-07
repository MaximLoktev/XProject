//
//  NewsFeedInteractor.swift
//  XProject
//
//  Created by Максим Локтев on 27.09.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import FirebaseDatabase
import Foundation

internal protocol NewsFeedBusinessLogic {
    func load(request: NewsFeedDataFlow.Load.Request)
    func refresh(request: NewsFeedDataFlow.Refresh.Request)
}

internal class NewsFeedInteractor: NewsFeedBusinessLogic {

    // MARK: - Properties

    var presenter: NewsFeedPresentationLogic?
    
    private var ref: DatabaseReference = DatabaseReference()
    
    private let sessionManager: SessionManager
    
    private let newsFeedFirebaseService: NewsFeedFirebaseService
    
    // MARK: - Init
    
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        self.newsFeedFirebaseService = NewsFeedFirebaseServiceImpl(databaseReference: ref,
                                                                   sessionManager: sessionManager)
    }
    
    // MARK: - NewFeedBusinessLogic

    func load(request: NewsFeedDataFlow.Load.Request) {
        newsFeedFirebaseService.fetchFeedPosts { [weak self] result in
            var response: NewsFeedDataFlow.Load.Response
            
            switch result {
            case.success(let postModel):
                response = NewsFeedDataFlow.Load.Response(result: .success(postModel))
            case.failure(let error):
                response = NewsFeedDataFlow.Load.Response(result: .failure(error))
            }
            self?.presenter?.presentLoad(response: response)
        }
    }
    
    func refresh(request: NewsFeedDataFlow.Refresh.Request) {
        newsFeedFirebaseService.fetchPostsFilter(key: .gender, value: request.title) { [weak self] result in
            var response: NewsFeedDataFlow.Refresh.Response
            
            switch result {
            case.success(let postModel):
                response = NewsFeedDataFlow.Refresh.Response(result: .success(postModel))
            case.failure(let error):
                response = NewsFeedDataFlow.Refresh.Response(result: .failure(error))
            }
            self?.presenter?.presentRefresh(response: response)
        }
    }

}
