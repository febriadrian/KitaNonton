//
//  HomeViewModel.swift
//  KitaNonton
//
//  Created by Febri Adrian on 25/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

protocol IHomeViewModel: class {
    var parameters: [String: Any]? { get }
    var mainViewController: MainViewController? { get }
}

class HomeViewModel: IHomeViewModel {
    var parameters: [String: Any]?
    var mainViewController: MainViewController?

    init(parameters: [String: Any]?) {
        self.parameters = parameters
    }
}
