//
//  TabBarController.swift
//  Connect
//
//  Created by Subham Padhi on 26/02/19.
//  Copyright © 2019 Subham Padhi. All rights reserved.
//
import FirebaseAuth
import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        
    }
    
    func setupTabs() {
        
        //let layout = UICollectionViewFlowLayout()
        let messagesViewController = MessagesViewController()
        let recentGroupsNavController = UINavigationController(rootViewController: messagesViewController)
        recentGroupsNavController.tabBarItem.title = "Messages"
      //  recentGroupsNavController.tabBarItem.image = #imageLiteral(resourceName: "class")
        
        
        let searchViewController = SearchViewController()
        let searchNavController = UINavigationController(rootViewController: searchViewController)
        searchNavController.tabBarItem.title = "Search"
      //  calenderNavController.tabBarItem.image = #imageLiteral(resourceName: "calendar-1")
        
        
        let settingsViewController = SettingsViewController()
        let settingsNavController = UINavigationController(rootViewController: settingsViewController)
        settingsNavController.tabBarItem.title = "Setting"
      //  wisdomNavController.tabBarItem.image = #imageLiteral(resourceName: "discover")
        
        
        var allViewControllers = [UIViewController]()
        
        
            allViewControllers.append(recentGroupsNavController)
            allViewControllers.append(searchNavController)
            allViewControllers.append(settingsNavController)
        
            self.viewControllers = allViewControllers
        
            selectedIndex = 0
    }
    

   

}
