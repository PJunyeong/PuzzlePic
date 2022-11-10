//
//  ViewController.swift
//  PuzzlePic
//
//  Created by Junyeong Park on 2022/11/10.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setTabBar()
    }
    
    private func setUI() {
        if #available(iOS 15, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .secondarySystemBackground
            tabBar.standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    private func setTabBar() {
        let vc1 = SearchViewController()
        let nav1 = UINavigationController(rootViewController: vc1)
        nav1.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "magnifyingglass.circle")?.withTintColor(.label, renderingMode: .alwaysOriginal), selectedImage: UIImage(systemName: "magnifyingglass.circle.fill")?.withTintColor(.label, renderingMode: .alwaysOriginal))
        
        let vc2 = PhotoHistoryViewController()
        let nav2 = UINavigationController(rootViewController: vc2)
        nav2.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "newspaper.circle")?.withTintColor(.label, renderingMode: .alwaysOriginal), selectedImage: UIImage(systemName: "newspaper.circle.fill")?.withTintColor(.label, renderingMode: .alwaysOriginal))
        setViewControllers([nav1, nav2], animated: true)
    }
    
}

