//
//  SwinJectContainer.swift
//  KitaNonton
//
//  Created by Febri Adrian on 25/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Swinject
import SwinjectAutoregistration

public class SwinjectContainer {
    class func getContainer() -> Container {
        let container = Container()
        container.autoregister(NetworkService.self, initializer: NetworkService.init)
        container.autoregister(MovieProvider.self, initializer: MovieProvider.init)
        return container
    }
}
