//
//  HomeMoviesInitializer.swift
//  KitaNonton
//
//  Created by Febri Adrian on 25/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

struct HomeMoviesInitializer {
    static func setup(parameters: [String: Any] = [:]) -> UIViewController {
        let viewController = HomeMoviesViewController()
        let router = HomeMoviesRouter(view: viewController)
        let container = SwinjectContainer.getContainer()
        let movieProvider = container.resolve(MovieProvider.self)
        let viewModel = HomeMoviesViewModel(movieProvider: movieProvider!,
                                            parameters: parameters)

        viewController.viewModel = viewModel
        viewController.router = router
        return viewController
    }
}
