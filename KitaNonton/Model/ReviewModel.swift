//
//  ReviewModel.swift
//  KitaNonton
//
//  Created by Febri Adrian on 26/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

struct ReviewModel {
    struct Request {
        var id: Int

        func parameters() -> [String: Any]? {
            return [
                "api_key": Constant.apiKey,
                "page": 1,
                "language": "en-US"
            ]
        }
    }

    struct Response: Codable {
        let id: Int?
        let page: Int?
        let totalPages: Int?
        let totalResults: Int?
        let results: [Results]?

        enum CodingKeys: String, CodingKey {
            case id, page
            case totalPages = "total_pages"
            case totalResults = "total_results"
            case results
        }

        struct Results: Codable {
            let id: String?
            let author: String?
            let content: String?
            let createdAt: String?
            let updatedAt: String?
            let url: String?
            let authorDetails: AuthorDetails?

            enum CodingKeys: String, CodingKey {
                case id, author, content, url
                case createdAt = "created_at"
                case updatedAt = "updated_at"
                case authorDetails = "author_details"
            }
            
            struct AuthorDetails: Codable {
                let username: String?
                let name: String?
                let rating: Int?
                let avatarPath: String?
                
                enum CodingKeys: String, CodingKey {
                    case username, name, rating
                    case avatarPath = "avatar_path"
                }
            }
        }
    }

    struct ViewModel {
        var author: String
        var content: String

        init(review: Response.Results) {
            self.author = review.author ?? "n/a"
            self.content = review.content ?? "n/a"
        }
    }
}
