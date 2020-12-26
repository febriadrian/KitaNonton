//
//  FavoriteMoviesViewModel.swift
//  KitaNonton
//
//  Created by Febri Adrian on 26/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation
import RealmSwift

protocol FavoriteMoviesViewModelDelegate {
    func displayMovies(movies: [MoviesModel.ViewModel])
    func displayUpdateFavorite(movies: [MoviesModel.ViewModel])
}

protocol IFavoriteMoviesViewModel: class {
    var parameters: [String: Any]? { get }
    var delegate: FavoriteMoviesViewModelDelegate? { get set }

    func getMovies()
    func observeRealmNotification()
}

 class FavoriteMoviesViewModel: IFavoriteMoviesViewModel {
    private var notificationToken: NotificationToken?
    private var realm: Realm?
    var parameters: [String: Any]?
    var delegate: FavoriteMoviesViewModelDelegate?
    var movies: [MoviesModel.ViewModel] = []

    init(parameters: [String: Any]?) {
        self.parameters = parameters

        do {
            self.realm = try Realm()
        } catch {
            TRACER(error.localizedDescription)
        }
    }

    func getMovies() {
        movies = TheFavorite.list()
        delegate?.displayMovies(movies: movies)
    }

    func updateFavorite() {
        for x in 0..<movies.count {
            let id = movies[x].id
            movies[x].favorite = TheFavorite.checkIsFavorite(id: id)
        }

        delegate?.displayUpdateFavorite(movies: movies)
    }

    func observeRealmNotification() {
        notificationToken = realm?.observe { [weak self] notification, _ in
            switch notification {
            case .didChange:
                TRACER("FavoriteMoviesViewModel | realm notified: .didChange")
            case .refreshRequired:
                TRACER("FavoriteMoviesViewModel | realm notified: .refreshRequired")
            }

            self?.updateFavorite()
        }
    }
 }
