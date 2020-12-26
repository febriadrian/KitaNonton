//
//  FavoriteService.swift
//  KitaNonton
//
//  Created by Febri Adrian on 26/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

let TheFavorite = FavoriteService.share

class FavoriteService: RealmService {
    static let share = FavoriteService()
    private var object = FavoriteObject()
    
    func save(movie: MoviesModel.ViewModel) {
        let object = FavoriteObject()
        object.createdAt = Int(Date().timeIntervalSince1970)
        object.favorite = true
        object.id = movie.id
        object.title = movie.title
        object.posterUrl = movie.posterUrl
        object.voteAverage = movie.voteAverage
        object.overview = movie.overview
        object.releaseDate = movie.releaseDate
        
        saveObject(object)
    }
    
    func list() -> [MoviesModel.ViewModel] {
        var movies = load(object).map { MoviesModel.ViewModel(favorite: $0) }
        movies.sort(by: { $0.createdAt > $1.createdAt })
        return movies
    }
    
    func checkIsFavorite(id: Int) -> Bool {
        return filteredBy(id).count == 1
    }
    
    func remove(id: Int) {
        guard let movie = filteredBy(id).first else { return }
        deleteObject(movie)
    }
    
    private func filteredBy(_ id: Int) -> [FavoriteObject] {
        let filter = "(id = \(id))"
        return load(object, filteredBy: filter)
    }
    
    func updateFavorite(movie: MoviesModel.ViewModel, favorite: Bool, completion: @escaping () -> Void) {
        if favorite {
            let topMostVC = UIApplication.shared.topMostViewController()
            let title = "Remove Favorite"
            let message = "Do You want to remove \(movie.title) from your favorite list?"
            let cancelTitle = "No"
            let submitTitle = "Yes"
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancel = UIAlertAction(title: cancelTitle, style: .cancel)
            let submit = UIAlertAction(title: submitTitle, style: .destructive) { [weak self] _ in
                self?.remove(id: movie.id)
                let message = "Removed from Favorites list"
                Toast.share.show(message: message)
                completion()
            }
            
            alert.addAction(cancel)
            alert.addAction(submit)
            topMostVC?.present(alert, animated: true, completion: nil)
        } else {
            save(movie: movie)
            let message = "Added to Favorites list"
            Toast.share.show(message: message)
            completion()
        }
    }
}
