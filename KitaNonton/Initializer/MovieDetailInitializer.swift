//
//  MovieDetailInitializer.swift
//  KitaNonton
//
//  Created by Febri Adrian on 26/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

struct MovieDetailInitializer {
    static func setup(parameters: [String: Any] = [:]) -> UIViewController {
        let viewController = MovieDetailViewController()
        let container = SwinjectContainer.getContainer()
        let movieProvider = container.resolve(MovieProvider.self)
        let viewModel = MovieDetailViewModel(movieProvider: movieProvider!,
                                             parameters: parameters)

        viewController.viewModel = viewModel
        return viewController
    }
}
