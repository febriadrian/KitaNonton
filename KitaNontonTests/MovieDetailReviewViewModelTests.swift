//
//  MovieDetailReviewViewModelTests.swift
//  KitaNontonTests
//
//  Created by Febri Adrian on 26/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

@testable import KitaNonton
import Mockingbird
import XCTest

class MovieDetailReviewViewModelTests: KitaNontonTests {
    var sut: MovieDetailReviewViewModel!

    override func setUp() {
        super.setUp()
        sut = MovieDetailReviewViewModel(movieProvider: movieProviderMock,
                                         parameters: parameters)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testGetReviewsSuccess() {
        let successResponse: ReviewModel.Response! = getMockResponse(mock: .getReviewsSuccessResponse)

        given(movieProviderMock.getReviews(id: any(),
                                           completion: any())) ~> {
            _, result in
            result(.success(successResponse))
        }

        sut.delegate = self
        sut.getReviews()

        verify(movieProviderMock.getReviews(id: any(),
                                            completion: any())).wasCalled()

        let expectedFirstAuthor = successResponse.results!.first!.author
        let firstAuthor = sut.review(at: 0).author
        XCTAssertEqual(firstAuthor, expectedFirstAuthor)
        XCTAssertEqual(sut.reviewsCount, successResponse.results?.count)
    }

    func testGetReviewsFailed() {
        let errorResponse: ErrorResponse! = getMockResponse(mock: .errorResponse)

        given(movieProviderMock.getReviews(id: any(),
                                           completion: any())) ~> {
            _, result in
            result(.failure(errorResponse))
        }

        sut.delegate = self
        sut.getReviews()

        verify(movieProviderMock.getReviews(id: any(),
                                            completion: any())).wasCalled()

        XCTAssertEqual(errorMessage, errorResponse.message)
    }
}

extension MovieDetailReviewViewModelTests: MovieDetailReviewDelegate {
    func displayGetMovies(result: GeneralResult) {
        switch result {
        case .success:
            print("success get reviews")
        case .failure(let message):
            errorMessage = message
        }
    }
}
