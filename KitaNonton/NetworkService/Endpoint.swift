//
//  Endpoint.swift
//  KitaNonton
//
//  Created by Febri Adrian on 24/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Alamofire
import Foundation

enum Endpoint {
    case popularMovies(model: MoviesModel.Request)
    case playingMovies(model: MoviesModel.Request)
    case upcomingMovies(model: MoviesModel.Request)
    case topratedMovies(model: MoviesModel.Request)
    case movieDetail(model: MovieDetailModel.Request)
    case movieReviews(model: ReviewModel.Request)
}

extension Endpoint: IEndpoint {
    var url: String {
        return Constant.apiBaseUrl + path
    }

    private var path: String {
        switch self {
        case .popularMovies:
            return "/movie/popular"
        case .playingMovies:
            return "/movie/now_playing"
        case .upcomingMovies:
            return "/movie/upcoming"
        case .topratedMovies:
            return "/movie/top_rated"
        case .movieDetail(let model):
            return "/movie/\(model.id)"
        case .movieReviews(let model):
            return "/movie/\(model.id)/reviews"
        }
    }

    var method: HTTPMethod {
        return .get
    }

    var parameters: Parameters? {
        switch self {
        case .popularMovies(let model):
            return model.parameters()
        case .playingMovies(let model):
            return model.parameters()
        case .upcomingMovies(let model):
            return model.parameters()
        case .topratedMovies(let model):
            return model.parameters()
        case .movieDetail(let model):
            return model.parameters()
        case .movieReviews(let model):
            return model.parameters()
        }
    }

    var encoding: ParameterEncoding {
        return URLEncoding.queryString
    }

    var headers: HTTPHeaders? {
        return [
            "Content-Type": "application/json",
        ]
    }
}
