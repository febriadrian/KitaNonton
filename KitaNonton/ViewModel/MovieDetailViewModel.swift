//
//  MovieDetailViewModel.swift
//  KitaNonton
//
//  Created by Febri Adrian on 26/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

protocol MovieDetailDelegate {
    func displayGetMovieDetail(detail: MovieDetailModel.MVDetailModel, trailers: [MovieDetailModel.YoutubeTrailerModel])
    func displayGetMovieDetailFailed(message: String)
    func displayUpdateFavorite(favorite: Bool)
}

protocol IMovieDetailViewModel: class {
    var delegate: MovieDetailDelegate? { get set }
    var parameters: [String: Any]? { get }
    var movieTitle: String { get }
    var movieId: Int { get }
    
    func getMovieDetail()
    func updateFavorite()
}

class MovieDetailViewModel: IMovieDetailViewModel {
    private let movieProvider: MovieProvider
    var delegate: MovieDetailDelegate?
    var parameters: [String: Any]?
    var detailValue: MovieDetailModel.MVDetailModel!
    var trailers: [MovieDetailModel.YoutubeTrailerModel] = []
    var isInitialLoading: Bool = true
    var isFavorite: Bool = false
    var movieId: Int = 0
    var resultsCount: Int?
    var errorMessage: String = ""
    
    init(movieProvider: MovieProvider, parameters: [String: Any]?) {
        self.movieProvider = movieProvider
        self.parameters = parameters
        self.movieId = parameters?["id"] as? Int ?? 0
    }
    
    var movieTitle: String {
        return detailValue.title
    }
    
    func getMovieDetail() {
        movieProvider.getMovieDetail(id: movieId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.detailValue = MovieDetailModel.MVDetailModel(response: response)
                self.isFavorite = self.detailValue.favorite
                self.setupTrailerViewModel(videos: response.videos)
                
                self.delegate?.displayGetMovieDetail(detail: self.detailValue, trailers: self.trailers)
            case .failure(let errorResponse):
                if let errorMessage = errorResponse?.message {
                    self.errorMessage = errorMessage
                } else {
                    self.errorMessage = Messages.generalError
                }
                self.delegate?.displayGetMovieDetailFailed(message: self.errorMessage)
            }
        }
    }
    
    func setupTrailerViewModel(videos: MovieDetailModel.Response.Videos?) {
        guard let videos = videos?.results else { return }
        for video in videos {
            if video.site?.lowercased() == "youtube", video.type?.lowercased() == "trailer" {
                let key = video.key ?? ""
                
                let videoUrl = URL(string: "https://www.youtube.com/watch?v=\(key)")
                let thumbnailUrl = "https://img.youtube.com/vi/\(key)/0.jpg"
                
                let trailer = MovieDetailModel.YoutubeTrailerModel(
                    videoUrl: videoUrl!,
                    thumbnailUrl: thumbnailUrl
                )
                
                trailers.append(trailer)
            }
        }
    }
    
    func updateFavorite() {
        let movie = MoviesModel.ViewModel(
            id: detailValue.id,
            title: detailValue.title,
            posterUrl: detailValue.posterPath,
            voteAverage: detailValue.voteAverage,
            overview: detailValue.overview,
            releaseDate: detailValue.releaseDate,
            favorite: isFavorite,
            createdAt: 0
        )
        
        TheFavorite.updateFavorite(movie: movie, favorite: isFavorite) { [weak self] in
            guard let self = self else { return }
            self.isFavorite.toggle()
            self.delegate?.displayUpdateFavorite(favorite: self.isFavorite)
        }
    }
}
