//
//  MovieDetailModel.swift
//  KitaNonton
//
//  Created by Febri Adrian on 26/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

struct MovieDetailModel {
    struct Request {
        var id: Int

        func parameters() -> [String: Any]? {
            return [
                "api_key": Constant.apiKey,
                "language": "en-US",
                "append_to_response": "videos"
            ]
        }
    }

    struct Response: Codable {
        let title: String?
        let originalTitle: String?
        let tagline: String?
        let overview: String?
        let releaseDate: String?
        let backdropPath: String?
        let posterPath: String?
        let homepage: String?
        let id: Int?
        let runtime: Int?
        let budget: Int?
        let revenue: Int?
        let voteAverage: Double?
        let genres: [Others]?
        let prodCompanies: [Others]?
        let prodCountries: [Others]?
        let videos: Videos?

        enum CodingKeys: String, CodingKey {
            case title, tagline, overview, homepage
            case id, runtime, budget, revenue
            case genres, videos
            case originalTitle = "original_title"
            case releaseDate = "release_date"
            case backdropPath = "backdrop_path"
            case posterPath = "poster_path"
            case voteAverage = "vote_average"
            case prodCompanies = "production_companies"
            case prodCountries = "production_countries"
        }

        struct Others: Codable {
            let name: String?

            enum CodingKeys: String, CodingKey {
                case name
            }
        }

        struct Videos: Codable {
            let results: [Detail]?

            enum CodingKeys: String, CodingKey {
                case results
            }

            struct Detail: Codable {
                let site: String?
                let type: String?
                let name: String?
                let key: String?

                enum CodingKeys: String, CodingKey {
                    case site, type, name, key
                }
            }
        }
    }

    struct MVDetailModel {
        var id: Int
        var title: String
        var originalTitle: String
        var tagline: String
        var overview: String
        var releaseDate: String
        var homepage: String
        var runtime: String
        var budget: String
        var revenue: String
        var voteAverage: String
        var genres: String
        var prodCompanies: String
        var prodCountries: String
        var backdropPath: String
        var posterPath: String
        var favorite: Bool

        init(response: Response) {
            var releaseDate: String?
            if let dateString = response.releaseDate {
                releaseDate = Helper.dateFormatter(dateString)
            }

            var budget: String?
            if let price = response.budget, price != 0 {
                budget = Helper.currencyFormatter(price: price)
            }

            var revenue: String?
            if let price = response.revenue, price != 0 {
                revenue = Helper.currencyFormatter(price: price)
            }

            var runtime: String?
            if let time = response.runtime {
                runtime = "\(time) minutes"
            }

            var voteAverage: String?
            if let rating = response.voteAverage, rating != 0 {
                voteAverage = "\(rating)"
            }

            var backdropPath: String?
            if let path = response.backdropPath, !path.isEmpty {
                backdropPath = "\(ImageUrl.backdrop.url)\(path)"
                backdropPath = ImageUrl.backdrop.url + path
            }

            var posterPath: String?
            if let path = response.posterPath, !path.isEmpty {
                posterPath = ImageUrl.poster.url + path
            }

            self.genres = "n/a"
            self.prodCompanies = "n/a"
            self.prodCountries = "n/a"
            self.id = response.id ?? 0
            self.title = response.title ?? "title is not available"
            self.originalTitle = response.originalTitle ?? "original title is not available"
            self.tagline = response.tagline ?? "n/a"
            self.overview = response.overview ?? "n/a"
            self.releaseDate = releaseDate ?? "n/a"
            self.homepage = response.homepage ?? "n/a"
            self.runtime = runtime ?? "n/a"
            self.budget = budget ?? "n/a"
            self.revenue = revenue ?? "n/a"
            self.voteAverage = voteAverage ?? "n/a"
            self.backdropPath = backdropPath ?? ""
            self.posterPath = posterPath ?? ""
            self.favorite = TheFavorite.checkIsFavorite(id: response.id ?? 0)

            var genres: String?
            if let array = response.genres {
                genres = self.getString(from: array)
            }

            var prodCompanies: String?
            if let array = response.prodCompanies {
                prodCompanies = self.getString(from: array)
            }

            var prodCountries: String?
            if let array = response.prodCountries {
                prodCountries = self.getString(from: array)
            }

            self.genres = genres ?? "n/a"
            self.prodCompanies = prodCompanies ?? "n/a"
            self.prodCountries = prodCountries ?? "n/a"
        }

        private func getString(from array: [MovieDetailModel.Response.Others]) -> String? {
            var stringArr: [String]?
            for x in array {
                if let name = x.name {
                    if stringArr == nil {
                        stringArr = [String]()
                    }

                    stringArr?.append(name)
                }
            }
            return Helper.arrayToString(stringArr)
        }
    }

    struct YoutubeTrailerModel {
        var videoUrl: URL
        var thumbnailUrl: String
    }
}
