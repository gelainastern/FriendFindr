//
//  CustomTabBarController.swift
//  ChatChat
//
//  Created by Gelaina Stern on 12/21/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

class CustomTabBarViewController: UITabBarController, CustomTabBarDataSource, CustomTabBarDelegate, UITabBarControllerDelegate, ChatViewDelegate {
    
    var customTabBar: CustomTabBar!
    var chatViewVC: ChatViewController? {
        didSet {
            chatViewVC?.delegate = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tabBar.isHidden = true
        self.selectedIndex = 1
        self.delegate = self
        
        
        customTabBar = CustomTabBar(frame: self.tabBar.frame)
        customTabBar?.datasource = self
        customTabBar?.delegate = self
        customTabBar?.setup()
        
        
        self.view.addSubview(customTabBar!)
    }
    
    
    func hideCustomTabBar() {
        customTabBar.isHidden = true
    }
    
    func showCustomTabBar() {
        
        customTabBar.isHidden = false
        self.tabBar.isHidden = true
    }
    
    
    
    // MARK: - CustomTabBarDataSource
    
    func tabBarItemsInCustomTabBar(_ tabBarView: CustomTabBar) -> [UITabBarItem] {
        return tabBar.items!
    }
    
    // MARK: - CustomTabBarDelegate
    
    func didSelectViewController(_ tabBarView: CustomTabBar, atIndex index: Int) {
        self.selectedIndex = index
    }
    
    // MARK: - UITabBarControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return CustomTabAnimatedTransitioning()
    }
    
}
