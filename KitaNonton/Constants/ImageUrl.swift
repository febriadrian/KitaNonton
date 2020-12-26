//
//  AppRouter.swift
//  KitaNonton
//
//  Created by Febri Adrian on 24/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

enum ImageUrl {
    case poster
    case profile
    case backdrop
}

extension ImageUrl {
    var url: String {
        switch self {
        case .poster, .profile:
            return Constant.imgBaseUrl + "w185"
        case .backdrop:
            return Constant.imgBaseUrl + "w300"
        }
    }
}
