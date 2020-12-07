//
//  ProfileDataManager.swift
//  XProject
//
//  Created by Максим Локтев on 15.09.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

internal class ProfileDataManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    
    struct Item: Equatable {
        let title: String
        let description: String
    }

    var items: [Item] = []
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = items[indexPath.row]
        let divisionForm = makeDivisionForm(index: indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withClass: ProfileDataCell.self, forIndexPath: indexPath)
        cell.setupCell(title: item.title, description: item.description, divisionForm: divisionForm)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60.0
    }
    
    private func makeDivisionForm(index: Int) -> DivisionForm {
        let item = items[index]
        
        if item == items.first {
            return .top
        } else if item == items.last {
            return .bottom
        } else {
            return .center
        }
    }
}
