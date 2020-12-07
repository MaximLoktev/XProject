//
//  NewsFeedDataManager.swift
//  XProject
//
//  Created by Максим Локтев on 05.10.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

internal class NewsFeedDataManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var posts: [PostModel] = []
    
    var selectedCellIndexPath: IndexPath?
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        posts.sort(by: { $0.date > $1.date })
        let post = posts[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withClass: NewsFeedCell.self, forIndexPath: indexPath)
        cell.setupCell(postModel: post)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedCellIndexPath != nil && selectedCellIndexPath == indexPath {
                selectedCellIndexPath = nil
            } else {
                selectedCellIndexPath = indexPath
            }

            tableView.beginUpdates()
            tableView.endUpdates()

            if selectedCellIndexPath != nil {
                // This ensures, that the cell is fully visible once expanded
                tableView.scrollToRow(at: indexPath, at: .none, animated: true)
            }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let post = posts[indexPath.row]
        
        if selectedCellIndexPath == indexPath {
            return NewsFeedCell.sizeFor(title: post.title, description: post.description ?? "")
        } else {
            return NewsFeedCell.sizeFor(title: post.title, description: "")
        }
    }
}
