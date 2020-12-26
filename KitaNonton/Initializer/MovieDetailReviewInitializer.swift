//
//  MovieDetailReviewInitializer.swift
//  KitaNonton
//
//  Created by Febri Adrian on 26/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

struct MovieDetailReviewInitializer {
    static func setup(parameters: [String: Any] = [:]) -> UIViewController {
        let viewController = MovieDetailReviewViewController()
        let container = SwinjectContainer.getContainer()
        let movieProvider = container.resolve(MovieProvider.self)
        let viewModel = MovieDetailReviewViewModel(movieProvider: movieProvider!,
                                                   parameters: parameters)

        viewController.viewModel = viewModel
        return viewController
    }
}
