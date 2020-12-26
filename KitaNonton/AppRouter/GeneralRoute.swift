//
//  GeneralRoute.swift
//  KitaNonton
//
//  Created by Febri Adrian on 24/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

enum GeneralRoute: IRouter {
    case homeMovies
    case movieDetail(parameter: [String: Any])
}

extension GeneralRoute {
    var module: UIViewController? {
        switch self {
        case .homeMovies:
            return HomeMoviesInitializer.setup()
        case .movieDetail(let parameter):
            return MovieDetailInitializer.setup(parameters: parameter)
        }
    }
}
