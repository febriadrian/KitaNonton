//
//  MovieDetailViewModelTests.swift
//  KitaNontonTests
//
//  Created by Febri Adrian on 26/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

@testable import KitaNonton
import Mockingbird
import XCTest

class MovieDetailViewModelTests: KitaNontonTests {
    var sut: MovieDetailViewModel!
    var isFavorite: Bool!
    
    override func setUp() {
        super.setUp()
        sut = MovieDetailViewModel(movieProvider: movieProviderMock,
                                   parameters: parameters)
    }
    
    override func tearDown() {
        sut = nil
        isFavorite = nil
        super.tearDown()
    }
    
    func testGetMovieDetailSuccess() {
        let successResponse: MovieDetailModel.Response! = getMockResponse(mock: .getMovieDetailSuccessResponse)
        
        given(movieProviderMock.getMovieDetail(id: any(),
                                               completion: any())) ~> {
            _, result in
            result(.success(successResponse))
        }
        
        sut.delegate = self
        sut.getMovieDetail()
        
        verify(movieProviderMock.getMovieDetail(id: any(),
                                                completion: any())).wasCalled()
        
        let expectedKey = successResponse.videos?.results?.first?.key
        let expectedThumbnailUrl = "https://img.youtube.com/vi/\(expectedKey!)/0.jpg"
        let thumbnailUrl = sut.trailers.first?.thumbnailUrl
        
        XCTAssertEqual(thumbnailUrl, expectedThumbnailUrl)
        XCTAssertEqual(sut.movieTitle, successResponse.title)
    }
    
    func testGetMovieDetailFailed() {
        let errorResponse: ErrorResponse! = getMockResponse(mock: .errorResponse)
        
        given(movieProviderMock.getMovieDetail(id: any(),
                                               completion: any())) ~> {
            _, result in
            result(.failure(errorResponse))
        }
        
        sut.delegate = self
        sut.getMovieDetail()
        
        verify(movieProviderMock.getMovieDetail(id: any(),
                                                completion: any())).wasCalled()
        
        XCTAssertEqual(errorMessage, errorResponse.message)
    }
    
    func testUpdateFavorite() {
        let successResponse: MovieDetailModel.Response! = getMockResponse(mock: .getMovieDetailSuccessResponse)
        
        given(movieProviderMock.getMovieDetail(id: any(),
                                               completion: any())) ~> {
            _, result in
            result(.success(successResponse))
        }
        
        sut.delegate = self
        sut.getMovieDetail()
        sut.updateFavorite()
        
        verify(movieProviderMock.getMovieDetail(id: any(),
                                                completion: any())).wasCalled()
        
        XCTAssertTrue(sut.isFavorite)
    }
}

extension MovieDetailViewModelTests: MovieDetailDelegate {
    func displayGetMovieDetail(detail: MovieDetailModel.MVDetailModel, trailers: [MovieDetailModel.YoutubeTrailerModel]) {
        print("success get movie detail")
    }
    
    func displayGetMovieDetailFailed(message: String) {
        errorMessage = message
    }
    
    func displayUpdateFavorite(favorite: Bool) {
        print("displayUpdateFavorite \(favorite)")
    }
}
