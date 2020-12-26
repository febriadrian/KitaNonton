//
//  KitaNontonTests.swift
//  KitaNontonTests
//
//  Created by Febri Adrian on 25/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

@testable import KitaNonton
import Mockingbird
import XCTest

class KitaNontonTests: XCTestCase {
    var networkServiceMock: NetworkServiceMock!
    var movieProviderMock: MovieProviderMock!
    var parameters: [String: Any]?
    var errorMessage: String!

    override func setUp() {
        super.setUp()
        networkServiceMock = mock(NetworkService.self)
        movieProviderMock = mock(MovieProvider.self).initialize(networkService: networkServiceMock)
    }

    override func tearDown() {
        networkServiceMock = nil
        movieProviderMock = nil
        parameters = nil
        errorMessage = nil
        super.tearDown()
    }
}
