//
//  MovieEnum.swift
//  KitaNonton
//
//  Created by Febri Adrian on 25/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

enum MovieCategory {
    case popular
    case playing
    case upcoming
    case toprated
}

enum MoviesResult {
    case successInitialLoading
    case successRefreshing
    case successLoadMore([IndexPath])
    case failureInitialLoading(String)
    case failureRefreshing(String)
    case failureLoadMore(String, IndexPath)
}

enum GeneralResult {
    case success
    case failure(String)
}
