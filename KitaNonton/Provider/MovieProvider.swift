//
//  MovieProvider.swift
//  KitaNonton
//
//  Created by Febri Adrian on 25/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

class MovieProvider {
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func getHomeMovies(category: MovieCategory, page: Int?, completion: @escaping MoviesResponseBlock) {
        let model = MoviesModel.Request(page: page)
        var endpoint: Endpoint

        switch category {
        case .popular:
            endpoint = .popularMovies(model: model)
        case .playing:
            endpoint = .playingMovies(model: model)
        case .upcoming:
            endpoint = .upcomingMovies(model: model)
        case .toprated:
            endpoint = .topratedMovies(model: model)
        }

        networkService.request(endpoint: endpoint, completion: completion)
    }

    func getMovieDetail(id: Int, completion: @escaping MovieDetailResponseBlock) {
        let model = MovieDetailModel.Request(id: id)

        networkService.request(endpoint: Endpoint.movieDetail(model: model), completion: completion)
    }

    func getReviews(id: Int, completion: @escaping ReviewResponseBlock) {
        let model = ReviewModel.Request(id: id)

        networkService.request(endpoint: Endpoint.movieReviews(model: model), completion: completion)
    }
}
