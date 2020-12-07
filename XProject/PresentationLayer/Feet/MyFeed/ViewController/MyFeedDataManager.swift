//
//  MyFeedDataManager.swift
//  XProject
//
//  Created by Максим Локтев on 11.11.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

internal class MyFeedDataManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var posts: [PostModel] = []
    
    var onEditPostDidTapped: ((PostModel) -> Void)?
    
    var onDeletePostDidTapped: ((PostModel) -> Void)?
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        posts.sort(by: { $0.date > $1.date })
        let post = posts[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withClass: MyFeedCell.self, forIndexPath: indexPath)
        cell.setupCell(postModel: post)
        cell.onEditPostDidTapped = onEditPostDidTapped
        cell.onDeletePostDidTapped = onDeletePostDidTapped
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let post = posts[indexPath.row]
        return MyFeedCell.sizeFor(title: post.title)
    }
}
