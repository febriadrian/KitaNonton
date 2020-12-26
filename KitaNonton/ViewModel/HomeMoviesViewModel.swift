//
//  HomeMoviesViewModel.swift
//  KitaNonton
//
//  Created by Febri Adrian on 25/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation
import RealmSwift

protocol HomeMoviesViewModelDelegate {
    func displayGetMovies(result: MoviesResult, movies: [MoviesModel.ViewModel])
    func displayUpdateFavorite(movies: [MoviesModel.ViewModel])
}

protocol IHomeMoviesViewModel: class {
    var delegate: HomeMoviesViewModelDelegate? { get set }
    var parameters: [String: Any]? { get }
    var totalResults: Int { get }
    var isInitialLoading: Bool { get }
    var isLoadingMore: Bool { get }

    func getMovies()
    func startLoadMore()
    func startRefreshing()
    func updateFavorite()
    func observeRealmNotification()
    func movie(at index: Int) -> MoviesModel.ViewModel
}

class HomeMoviesViewModel: IHomeMoviesViewModel {
    private let movieProvider: MovieProvider
    private var notificationToken: NotificationToken?
    private var realm: Realm?
    var delegate: HomeMoviesViewModelDelegate?
    var parameters: [String: Any]?
    var page: Int = 1
    var totalResults: Int = 100
    var isInitialLoading: Bool = true
    var isRefreshing: Bool = false
    var isLoadingMore: Bool = false
    var category: MovieCategory = .playing
    var movieResult: MoviesResult = .successInitialLoading
    var movies: [MoviesModel.ViewModel] = []
    var errorMessage: String = ""

    init(movieProvider: MovieProvider, parameters: [String: Any]?) {
        self.movieProvider = movieProvider
        self.parameters = parameters
        category = parameters?["category"] as? MovieCategory ?? .playing

        do {
            realm = try Realm()
        } catch {
            TRACER(error.localizedDescription)
        }
    }

    func movie(at index: Int) -> MoviesModel.ViewModel {
        return movies[index]
    }

    func startLoadMore() {
        isLoadingMore = true
        page += 1
        getMovies()
    }

    func startRefreshing() {
        isRefreshing = true
        page = 1
        totalResults = 100
        getMovies()
    }

    func updateFavorite() {
        for x in 0..<movies.count {
            let id = movies[x].id
            movies[x].favorite = TheFavorite.checkIsFavorite(id: id)
        }

        delegate?.displayUpdateFavorite(movies: movies)
    }

    func getMovies() {
        movieProvider.getHomeMovies(category: category, page: page) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                guard let results = response.results else {
                    self.errorMessage = Messages.noMovies
                    self.handleMovieError()
                    return
                }

                let newMovies = results.compactMap { MoviesModel.ViewModel(movie: $0) }

                if self.isLoadingMore {
                    var indexPaths: [IndexPath] = []

                    for x in 0..<newMovies.count {
                        let indexPath: IndexPath = [0, self.movies.count + x]
                        indexPaths.append(indexPath)
                    }

                    self.isLoadingMore = false
                    self.movies += newMovies
                    self.movieResult = .successLoadMore(indexPaths)
                } else {
                    self.movies = newMovies

                    if self.isRefreshing {
                        self.isRefreshing = false
                        self.movieResult = .successRefreshing
                    } else {
                        self.isInitialLoading = false
                        self.movieResult = .successInitialLoading
                    }
                }

                if let page = response.page, let totalResults = response.totalResults {
                    self.page = page
                    self.totalResults = totalResults
                }

                self.delegate?.displayGetMovies(result: self.movieResult, movies: self.movies)
            case .failure(let errorResponse):
                if let errorMessage = errorResponse?.message {
                    self.errorMessage = errorMessage
                } else {
                    self.errorMessage = Messages.generalError
                }
                self.handleMovieError()
            }
        }
    }

    func handleMovieError() {
        if isLoadingMore {
            isLoadingMore = false
            page -= 1
            let indexPath = IndexPath(item: movies.count - 1, section: 0)
            movieResult = .failureLoadMore(errorMessage, indexPath)
        } else if isRefreshing {
            isRefreshing = false
            movieResult = .failureRefreshing(errorMessage)
        } else {
            isInitialLoading = false
            movieResult = .failureInitialLoading(errorMessage)
        }

        delegate?.displayGetMovies(result: movieResult, movies: movies)
    }

    func observeRealmNotification() {
        notificationToken = realm?.observe { [weak self] notification, _ in
            TRACER("HomeViewModel | recevied realm notification \(notification)")
            self?.updateFavorite()
        }
    }
}
