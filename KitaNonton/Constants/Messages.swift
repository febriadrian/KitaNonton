//
//  AppRouter.swift
//  KitaNonton
//
//  Created by Febri Adrian on 24/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

struct Messages {
    static let loading = "Please wait.."
    static let noMovies = "No Movies Found"
    static let noInternet = "No Internet Connection"
    static let noReviews = "No Reviews Found"
    static let unknownError = "Unknown Error"
    static let noFavoriteMovies = "You have no Favorite Movies.."
    
    static let generalError: String = {
        if NetworkStatus.isInternetAvailable {
            return unknownError
        }
        return noInternet
    }()
}
