//
//  MovieDetailInfoInitializer.swift
//  KitaNonton
//
//  Created by Febri Adrian on 26/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

struct MovieDetailInfoInitializer {
    static func setup(parameters: [String: Any] = [:]) -> UIViewController {
        let viewController = MovieDetailInfoViewController()
        return viewController
    }
}
