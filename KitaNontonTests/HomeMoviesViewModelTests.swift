//
//  HomeMoviesViewModelTests.swift
//  KitaNontonTests
//
//  Created by Febri Adrian on 25/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

@testable import KitaNonton
import Mockingbird
import XCTest

class HomeMoviesViewModelTests: KitaNontonTests {
    var sut: HomeMoviesViewModel!
    var updatedMovies: [MoviesModel.ViewModel]!
    
    override func setUp() {
        super.setUp()
        sut = HomeMoviesViewModel(movieProvider: movieProviderMock,
                                  parameters: parameters)
    }
    
    override func tearDown() {
        sut = nil
        updatedMovies = nil
        super.tearDown()
    }
    
    func testGetMoviesInitialLoadingSuccess() {
        let index = 0
        let successResponse: MoviesModel.Response! = getMockResponse(mock: .getMoviesSuccessResponse)
        
        given(movieProviderMock.getHomeMovies(category: any(),
                                              page: any(),
                                              completion: any())) ~> {
            _, _, result in
            result(.success(successResponse))
        }
        
        sut.delegate = self
        sut.getMovies()
        
        verify(movieProviderMock.getHomeMovies(category: any(),
                                               page: any(),
                                               completion: any())).wasCalled()
        
        let expectedFirstTitle = successResponse.results?[index].title
        let firstTitle = sut.movie(at: index).title
        XCTAssertEqual(firstTitle, expectedFirstTitle)
    }
    
    func testGetMoviesLoadMoreSuccess() {
        let index = 0
        let successResponse: MoviesModel.Response! = getMockResponse(mock: .getMoviesSuccessResponse)
        
        given(movieProviderMock.getHomeMovies(category: any(),
                                              page: any(),
                                              completion: any())) ~> {
            _, _, result in
            result(.success(successResponse))
        }
        
        sut.delegate = self
        sut.startLoadMore()
        
        verify(movieProviderMock.getHomeMovies(category: any(),
                                               page: any(),
                                               completion: any())).wasCalled()
        
        let expectedFirstTitle = successResponse.results?[index].title
        let firstTitle = sut.movie(at: index).title
        XCTAssertEqual(firstTitle, expectedFirstTitle)
    }
    
    func testGetMoviesRefreshingSuccess() {
        let index = 0
        let successResponse: MoviesModel.Response! = getMockResponse(mock: .getMoviesSuccessResponse)
        
        given(movieProviderMock.getHomeMovies(category: any(),
                                              page: any(),
                                              completion: any())) ~> {
            _, _, result in
            result(.success(successResponse))
        }
        
        sut.delegate = self
        sut.startRefreshing()
        
        verify(movieProviderMock.getHomeMovies(category: any(),
                                               page: any(),
                                               completion: any())).wasCalled()
        
        let expectedFirstTitle = successResponse.results?[index].title
        let firstTitle = sut.movie(at: index).title
        XCTAssertEqual(firstTitle, expectedFirstTitle)
    }
    
    func testGetMoviesInitialLoadingFailed() {
        let errorResponse: ErrorResponse! = getMockResponse(mock: .errorResponse)
        
        given(movieProviderMock.getHomeMovies(category: any(),
                                              page: any(),
                                              completion: any())) ~> {
            _, _, result in
            result(.failure(errorResponse))
        }
        
        sut.delegate = self
        sut.getMovies()
        
        verify(movieProviderMock.getHomeMovies(category: any(),
                                               page: any(),
                                               completion: any())).wasCalled()
        
        XCTAssertEqual(errorMessage, errorResponse.message)
    }
    
    func testGetMoviesLoadMoreFailed() {
        let errorResponse: ErrorResponse! = getMockResponse(mock: .errorResponse)
        
        given(movieProviderMock.getHomeMovies(category: any(),
                                              page: any(),
                                              completion: any())) ~> {
            _, _, result in
            result(.failure(errorResponse))
        }
        
        sut.delegate = self
        sut.startLoadMore()
        
        verify(movieProviderMock.getHomeMovies(category: any(),
                                               page: any(),
                                               completion: any())).wasCalled()
        
        XCTAssertEqual(errorMessage, nil)
    }
    
    func testGetMoviesRefreshingFailed() {
        let errorResponse: ErrorResponse! = getMockResponse(mock: .errorResponse)
        
        given(movieProviderMock.getHomeMovies(category: any(),
                                              page: any(),
                                              completion: any())) ~> {
            _, _, result in
            result(.failure(errorResponse))
        }
        
        sut.delegate = self
        sut.startRefreshing()
        
        verify(movieProviderMock.getHomeMovies(category: any(),
                                               page: any(),
                                               completion: any())).wasCalled()
        
        XCTAssertEqual(errorMessage, errorResponse.message)
    }
    
    func testUpdateFavorite() {
        let successResponse: MoviesModel.Response! = getMockResponse(mock: .getMoviesSuccessResponse)
        
        given(movieProviderMock.getHomeMovies(category: any(),
                                              page: any(),
                                              completion: any())) ~> {
            _, _, result in
            result(.success(successResponse))
        }
        
        sut.delegate = self
        sut.getMovies()
        sut.updateFavorite()
        
        verify(movieProviderMock.getHomeMovies(category: any(),
                                               page: any(),
                                               completion: any())).wasCalled()
        
        XCTAssertEqual(sut.movies, updatedMovies)
    }
}

extension HomeMoviesViewModelTests: HomeMoviesViewModelDelegate {
    func displayGetMovies(result: MoviesResult, movies: [MoviesModel.ViewModel]) {
        switch result {
        case .failureInitialLoading(let message),
             .failureLoadMore(let message, []),
             .failureRefreshing(let message):
            errorMessage = message
        default:
            print("succces get movies")
        }
    }
    
    func displayUpdateFavorite(movies: [MoviesModel.ViewModel]) {
        updatedMovies = movies
    }
}
