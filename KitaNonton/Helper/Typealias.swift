//
//  Typealias.swift
//  KitaNonton
//
//  Created by Febri Adrian on 26/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

typealias KNVoidCompletion = () -> Void
typealias MoviesResponseBlock = (FetchResult<MoviesModel.Response, ErrorResponse?>) -> Void
typealias MovieDetailResponseBlock = (FetchResult<MovieDetailModel.Response, ErrorResponse?>) -> Void
typealias ReviewResponseBlock = (FetchResult<ReviewModel.Response, ErrorResponse?>) -> Void
