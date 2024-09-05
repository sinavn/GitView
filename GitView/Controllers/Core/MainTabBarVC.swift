//
//  MainTabBarVC.swift
//  GitView
//
//  Created by Sina Vosough Nia on 5/22/1403 AP.
//

import UIKit

class MainTabBarVC: UITabBarController {
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let searchNC = UINavigationController(rootViewController: SearchVC())
        searchNC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        let favoriteListNC = UINavigationController(rootViewController: FavoriteListVC())
        favoriteListNC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        tabBar.tintColor = .label
        
        setViewControllers([searchNC , favoriteListNC], animated: true)
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        
        }
    

 

}
