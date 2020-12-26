//
//  MovieDetailReviewViewModel.swift
//  KitaNonton
//
//  Created by Febri Adrian on 26/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

protocol MovieDetailReviewDelegate {
    func displayGetMovies(result: GeneralResult)
}

protocol IMovieDetailReviewViewModel {
    var delegate: MovieDetailReviewDelegate? { get set }
    var parameters: [String: Any]? { get }
    var reviewsCount: Int { get }

    func getReviews()
    func review(at index: Int) -> ReviewModel.ViewModel
}

class MovieDetailReviewViewModel: IMovieDetailReviewViewModel {
    private let movieProvider: MovieProvider
    var delegate: MovieDetailReviewDelegate?
    var parameters: [String: Any]?
    var reviews: [ReviewModel.ViewModel] = []
    var id: Int = 0

    init(movieProvider: MovieProvider, parameters: [String: Any]?) {
        self.movieProvider = movieProvider
        self.parameters = parameters
        
        id = parameters?["id"] as? Int ?? 0
    }

    var reviewsCount: Int {
        return reviews.count
    }

    func review(at index: Int) -> ReviewModel.ViewModel {
        return reviews[index]
    }

    func getReviews() {
        movieProvider.getReviews(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if let results = response.results, results.count > 0 {
                    self.reviews = results.map { ReviewModel.ViewModel(review: $0) }
                    self.delegate?.displayGetMovies(result: .success)
                } else {
                    self.delegate?.displayGetMovies(result: .failure(Messages.noReviews))
                }
            case .failure(let errorResponse):
                if let errorMessage = errorResponse?.message {
                    self.delegate?.displayGetMovies(result: .failure(errorMessage))
                } else {
                    self.delegate?.displayGetMovies(result: .failure(Messages.generalError))
                }
            }
        }
    }
}
