//
//  FeedDataManager.swift
//  XProject
//
//  Created by Максим Локтев on 27.09.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import UIKit

class FeedDataManager: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // MARK: - Properties
    
    var arrayViewController: [UIViewController] = []
    
    var activeSegment: ((Int) -> Void)?
    
    // MARK: - UIPageViewControllerDelegate
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        
        guard
            let currentViewController = pageViewController.viewControllers?.first,
            let currentIndex = arrayViewController.firstIndex(of: currentViewController) else {
            return
        }
        
        activeSegment?(currentIndex)
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = arrayViewController.firstIndex(of: viewController) {
            if index > 0 {
                return arrayViewController[index - 1]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = arrayViewController.firstIndex(of: viewController) {
            if index < arrayViewController.count - 1 {
                return arrayViewController[index + 1]
            }
        }
        return nil
    }
}
