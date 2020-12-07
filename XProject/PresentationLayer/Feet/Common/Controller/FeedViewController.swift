//
//  FeetViewController.swift
//  XProject
//
//  Created by Максим Локтев on 02.07.2020.
//  Copyright © 2020 Максим Локтев. All rights reserved.
//

import AVFoundation
import Kingfisher
import UIKit

internal protocol FeedModuleOutput: class {
    func feedModuleOutputDidSelectFilter(title: String)
    func feedModuleDidShowCreatePost()
    func feedModuleDidShowEditPost(post: PostModel)
}

internal protocol FeedModuleInput: class {
    func feetModuleInputSelectFilter(title: String)
}

internal protocol FeedModuleBuilders {
    var newsFeed: NewsFeedBuildable { get }
    var myFeed: MyFeedBuildable { get }
}

internal class FeedViewController: UIViewController, FeedModuleInput, FeedViewDelegate,
                                   NewsFeedModuleOutput, MyFeedModuleOutput {
    
    // MARK: - Properties

    weak var moduleOutput: FeedModuleOutput?

    var moduleView: FeedView!
    
    private let dataManager = FeedDataManager()
    
    private(set) lazy var pages: [UIViewController] = [UIViewController]()
    
    private let builders: FeedModuleBuilders
    
    private let pageViewController: UIPageViewController = UIPageViewController(transitionStyle: .scroll,
                                                                                navigationOrientation: .horizontal,
                                                                                options: nil)
    private var actionTitle = "Все"
    
    init(builders: FeedModuleBuilders) {
        self.builders = builders
        super.init(nibName: nil, bundle: nil)
        
        pages = [
            builders.newsFeed.build(withModuleOutput: self),
            builders.myFeed.build(withModuleOutput: self)
        ]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle

    override func loadView() {
        addChild(pageViewController)
        moduleView = FeedView(frame: UIScreen.main.bounds,
                              pageView: pageViewController.view)
        pageViewController.didMove(toParent: self)
        moduleView.delegate = self
        view = moduleView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageViewController.view.backgroundColor = .white
        navigationItem.title = "Лента"
        
        pages.append(NewsFeedViewController())
        
        if pages.count > 1 {
            let firstViewController = pages[0]
            pageViewController.setViewControllers([firstViewController],
                                                  direction: .forward,
                                                  animated: false,
                                                  completion: nil)
        }
        
        navigationControllerSetting(navigationController: navigationController)
        createdBarButton(index: 0, title: actionTitle)
        setupDataManager()
    }
    
    func feetModuleInputSelectFilter(title: String) {
        if let newsFeedViewController = pages[0] as? NewsFeedViewController {
            newsFeedViewController.newsFeedModuleInputSelectFilter(title: title)
        }
    }
    
    // MARK: - MyFeedModuleOutput
    
    func myFeedModuleDidShowEditPost(post: PostModel) {
        moduleOutput?.feedModuleDidShowEditPost(post: post)
    }
    
    // MARK: - Actions
    
    func viewDidNextPageController(index: Int) {
        guard
            index < pages.count,
            let currentViewController = pageViewController.viewControllers?.first,
            let currentIndex = pages.firstIndex(of: currentViewController),
            index != currentIndex
        else {
            return
        }
                
        let direction: UIPageViewController.NavigationDirection = (index > currentIndex) ? .forward : .reverse
        let viewController = pages[index]
        pageViewController.setViewControllers([viewController], direction: direction, animated: false)
        createdBarButton(index: index, title: actionTitle)
    }
    
    @objc
    func viewDidTapNextButton() {
        moduleOutput?.feedModuleDidShowCreatePost()
    }
    
    private func navigationControllerSetting(navigationController: UINavigationController?) {
        guard let navigationController = navigationController else {
            return
        }
        navigationController.navigationBar.barTintColor = .white
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19.0, weight: .medium)
        ]
    }
    #warning("Переделать barButtonMenu!!!")
    private func createdBarButton(index: Int, title: String) {
//        let barButtonMenu = UIMenu(title: "Сфера деятельности", options: .displayInline, children: [
//            UIAction(title: NSLocalizedString("Все", comment: ""), image: nil, state: .off, handler: sortedPost),
//            UIAction(title: NSLocalizedString("iOS", comment: ""), image: nil, state: .off, handler: sortedPost),
//            UIAction(title: NSLocalizedString("Android", comment: ""), image: nil, state: .off, handler: sortedPost),
//            UIAction(title: NSLocalizedString("PHP", comment: ""), image: nil, state: .off, handler: sortedPost)
//        ])
        var barButtonItem = UIBarButtonItem()
        
        if index == 0 {
            barButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                            target: self,
                                            action: nil)
            
            if #available(iOS 14.0, *) {
                barButtonItem.menu = barButtonMenu(title: title)
            }
        } else {
            barButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                            target: self,
                                            action: #selector(viewDidTapNextButton))
        }
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    private func barButtonMenu(title: String) -> UIMenu {
        var barButtonMenu: UIMenu
        
        if title == "iOS" {
            barButtonMenu = UIMenu(title: "Сфера деятельности", options: .displayInline, children: [
                UIAction(title: NSLocalizedString("Все", comment: ""), image: #imageLiteral(resourceName: "iconAll"), state: .off, handler: sortedPost),
                UIAction(title: NSLocalizedString("iOS", comment: ""), image: #imageLiteral(resourceName: "apple"), state: .on, handler: sortedPost),
                UIAction(title: NSLocalizedString("Android", comment: ""), image: #imageLiteral(resourceName: "android"), state: .off, handler: sortedPost),
                UIAction(title: NSLocalizedString("PHP", comment: ""), image: #imageLiteral(resourceName: "php"), state: .off, handler: sortedPost)
            ])
            return barButtonMenu
            
        } else if title == "Android" {
            barButtonMenu = UIMenu(title: "Сфера деятельности", options: .displayInline, children: [
                UIAction(title: NSLocalizedString("Все", comment: ""), image: #imageLiteral(resourceName: "iconAll"), state: .off, handler: sortedPost),
                UIAction(title: NSLocalizedString("iOS", comment: ""), image: #imageLiteral(resourceName: "apple"), state: .off, handler: sortedPost),
                UIAction(title: NSLocalizedString("Android", comment: ""), image: #imageLiteral(resourceName: "android"), state: .on, handler: sortedPost),
                UIAction(title: NSLocalizedString("PHP", comment: ""), image: #imageLiteral(resourceName: "php"), state: .off, handler: sortedPost)
            ])
            return barButtonMenu
            
        } else if title == "PHP" {
            barButtonMenu = UIMenu(title: "Сфера деятельности", options: .displayInline, children: [
                UIAction(title: NSLocalizedString("Все", comment: ""), image: #imageLiteral(resourceName: "iconAll"), state: .off, handler: sortedPost),
                UIAction(title: NSLocalizedString("iOS", comment: ""), image: #imageLiteral(resourceName: "apple"), state: .off, handler: sortedPost),
                UIAction(title: NSLocalizedString("Android", comment: ""), image: #imageLiteral(resourceName: "android"), state: .off, handler: sortedPost),
                UIAction(title: NSLocalizedString("PHP", comment: ""), image: #imageLiteral(resourceName: "php"), state: .on, handler: sortedPost)
            ])
            return barButtonMenu
            
        } else {
            barButtonMenu = UIMenu(title: "Сфера деятельности", options: .displayInline, children: [
                UIAction(title: NSLocalizedString("Все", comment: ""), image: #imageLiteral(resourceName: "iconAll"), state: .on, handler: sortedPost),
                UIAction(title: NSLocalizedString("iOS", comment: ""), image: #imageLiteral(resourceName: "apple"), state: .off, handler: sortedPost),
                UIAction(title: NSLocalizedString("Android", comment: ""), image: #imageLiteral(resourceName: "android"), state: .off, handler: sortedPost),
                UIAction(title: NSLocalizedString("PHP", comment: ""), image: #imageLiteral(resourceName: "php"), state: .off, handler: sortedPost)
            ])
            
            if let newsFeedViewController = pages[0] as? NewsFeedViewController {
                newsFeedViewController.newsFeedModuleInputSelectFilter(title: actionTitle)
            }
            
            return barButtonMenu
        }
    }
    
    private func sortedPost(action: UIAction) {
        actionTitle = action.title
        createdBarButton(index: 0, title: actionTitle)
        
        if let newsFeedViewController = pages[0] as? NewsFeedViewController {
            newsFeedViewController.newsFeedModuleInputSelectFilter(title: actionTitle)
        }
    }
    
    // MARK: - Data manager
    
    private func setupDataManager() {
        pageViewController.delegate = dataManager
        pageViewController.dataSource = dataManager
        dataManager.arrayViewController = pages
        
        dataManager.activeSegment = { [weak self] index in
            guard let self = self else {
                return
            }
            self.moduleView.setupSegmentControl(index: index)
            self.createdBarButton(index: index, title: self.actionTitle)
        }
    }
}
