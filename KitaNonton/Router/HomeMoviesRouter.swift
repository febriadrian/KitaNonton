//
//  HomeMoviesRouter.swift
//  KitaNonton
//
//  Created by Febri Adrian on 25/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

protocol IHomeMoviesRouter: class {
    func navToMovieDetail(id: Int)
}

class HomeMoviesRouter: IHomeMoviesRouter {
    weak var view: HomeMoviesViewController?

    init(view: HomeMoviesViewController) {
        self.view = view
    }

    func navToMovieDetail(id: Int) {
        view?.navigate(type: .push, module: GeneralRoute.movieDetail(parameter: [
            "id": id
        ]), completion: nil)
    }
}
