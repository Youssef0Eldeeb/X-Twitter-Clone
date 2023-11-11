//
//  MainTabbarViewController.swift
//  TwitterClone
//
//  Created by Youssef Eldeeb on 11/11/2023.
//

import UIKit

class MainTabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray2
        
        
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: SearchViewController())
        let vc3 = UINavigationController(rootViewController: NotificationViewController())
        let vc4 = UINavigationController(rootViewController: MessagesViewController())
        
        vc1.tabBarItem = UITabBarItem(title: nil,
                                      image: UIImage(systemName: "house")
                                      , selectedImage: UIImage(systemName: "house.fill"))
        vc2.tabBarItem = UITabBarItem(title: nil,
                                      image: UIImage(systemName: "magnifyingglass")
                                      , selectedImage: nil)
        vc3.tabBarItem = UITabBarItem(title: nil,
                                      image: UIImage(systemName: "bell")
                                      , selectedImage: UIImage(systemName: "bell.fill"))
        vc4.tabBarItem = UITabBarItem(title: nil,
                                      image: UIImage(systemName: "envelope")
                                      , selectedImage: UIImage(systemName: "envelope.fill"))
    
        self.setViewControllers([vc1, vc2, vc3, vc4], animated: true)
        
    }
    
    

}
