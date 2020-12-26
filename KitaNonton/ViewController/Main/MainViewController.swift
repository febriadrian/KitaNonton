//
//  MainViewController.swift
//  KitaNonton
//
//  Created by Febri Adrian on 25/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

protocol MainViewControllerDelegate {
    func scrollToTop()
}

class MainViewController: UITabBarController {
    var mainViewControllerDelegate: MainViewControllerDelegate?
    var home: HomeViewController!
    var favorite: FavoriteMoviesViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        let parameter = ["mainvc": self]

        home = HomeInitializer.setup(parameters: parameter) as? HomeViewController
        home.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "tab_home"), tag: 0)
        
        favorite = FavoriteMoviesInitializer.setup(parameters: parameter) as? FavoriteMoviesViewController
        favorite.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(named: "tab_favorite"), tag: 1)
        
        viewControllers = [home, favorite].map { UINavigationController(rootViewController: $0) }
        tabBar.tintColor = Colors.lightBlue
        delegate = self
    }
}

extension MainViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        mainViewControllerDelegate?.scrollToTop()
    }
}
