//
//  HomeInitializer.swift
//  KitaNonton
//
//  Created by Febri Adrian on 25/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

struct HomeInitializer {
    static func setup(parameters: [String: Any] = [:]) -> UIViewController {
        let viewController = HomeViewController()
        let viewModel = HomeViewModel(parameters: parameters)

        viewController.viewModel = viewModel
        return viewController
    }
}
