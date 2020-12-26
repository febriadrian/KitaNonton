//
//  MoviesModel.swift
//  KitaNonton
//
//  Created by Febri Adrian on 25/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

struct MoviesModel {
    struct Request {
        var page: Int?

        func parameters() -> [String: Any]? {
            return [
                "api_key": Constant.apiKey,
                "page": page ?? 1,
                "language": "en-US"
            ]
        }
    }

    struct Response: Codable {
        let page: Int?
        let totalResults: Int?
        let totalPages: Int?
        let results: [Results]?

        enum CodingKeys: String, CodingKey {
            case page
            case results
            case totalResults = "total_results"
            case totalPages = "total_pages"
        }

        struct Results: Codable {
            let id: Int?
            let title: String?
            let posterPath: String?
            let overview: String?
            let releaseDate: String?
            let voteAverage: Double?

            enum CodingKeys: String, CodingKey {
                case id
                case title
                case overview
                case posterPath = "poster_path"
                case releaseDate = "release_date"
                case voteAverage = "vote_average"
            }
        }
    }

    struct ViewModel: Equatable {
        var id: Int
        var title: String
        var posterUrl: String
        var voteAverage: String
        var overview: String
        var releaseDate: String
        var favorite: Bool
        var createdAt: Int
        
        init(id: Int, title: String, posterUrl: String, voteAverage: String, overview: String, releaseDate: String, favorite: Bool, createdAt: Int) {
            self.id = id
            self.title = title
            self.posterUrl = posterUrl
            self.voteAverage = voteAverage
            self.overview = overview
            self.releaseDate = releaseDate
            self.favorite = favorite
            self.createdAt = createdAt
        }

        init(movie: Response.Results) {
            self.id = movie.id ?? 0
            self.title = movie.title ?? "title is not available"
            self.posterUrl = "\(ImageUrl.poster.url)\(movie.posterPath ?? "")"
            self.voteAverage = movie.voteAverage == nil ? "n/a" : "\(movie.voteAverage!)"
            self.overview = movie.overview ?? "overview is not available"
            self.createdAt = 0
            self.releaseDate = Helper.dateFormatter(movie.releaseDate)
            self.favorite = FavoriteService.share.checkIsFavorite(id: movie.id ?? 0)
        }

        init(favorite: FavoriteObject) {
            self.id = favorite.id
            self.title = favorite.title
            self.posterUrl = favorite.posterUrl
            self.voteAverage = favorite.voteAverage
            self.overview = favorite.overview
            self.releaseDate = favorite.releaseDate
            self.favorite = favorite.favorite
            self.createdAt = favorite.createdAt
        }
    }
}
