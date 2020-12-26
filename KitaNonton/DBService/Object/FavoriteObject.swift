//
//  FavoriteObject.swift
//  KitaNonton
//
//  Created by Febri Adrian on 26/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import RealmSwift

class FavoriteObject: Object {
    @objc dynamic var createdAt: Int = 0
    @objc dynamic var favorite: Bool = false
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var posterUrl: String = ""
    @objc dynamic var voteAverage: String = ""
    @objc dynamic var overview: String = ""
    @objc dynamic var releaseDate: String = ""

    override class func primaryKey() -> String? {
        return "id"
    }
}
