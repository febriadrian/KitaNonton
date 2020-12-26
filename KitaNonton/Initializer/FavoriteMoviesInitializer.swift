//
//  FavoriteMoviesInitializer.swift
//  KitaNonton
//
//  Created by Febri Adrian on 26/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

struct FavoriteMoviesInitializer {
    static func setup(parameters: [String: Any] = [:]) -> UIViewController {
        let viewController = FavoriteMoviesViewController()
        let router = FavoriteMoviesRouter(view: viewController)
        let viewModel = FavoriteMoviesViewModel(parameters: parameters)

        viewController.viewModel = viewModel
        viewController.router = router
        return viewController
    }
}
