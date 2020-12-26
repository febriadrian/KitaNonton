//
//  RealmService.swift
//  KitaNonton
//
//  Created by Febri Adrian on 26/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import RealmSwift

class RealmService {
    private var realm: Realm?

    init() {
        do {
            self.realm = try Realm()
        } catch {
            TRACER(error.localizedDescription)
        }
    }

    func saveObject(_ object: Object, otherTasks: (KNVoidCompletion)? = nil) {
        do {
            try realm?.write {
                otherTasks?()
                realm?.add(object, update: .all)
            }
        } catch {
            TRACER(error.localizedDescription)
        }
    }

    func deleteObject(_ object: Object, otherTasks: (KNVoidCompletion)? = nil) {
        do {
            try realm?.write {
                otherTasks?()
                realm?.delete(object)
            }
        } catch {
            TRACER(error.localizedDescription)
        }
    }

    func deleteAllObject(_ objects: [Object], otherTasks: (KNVoidCompletion)? = nil) {
        objects.forEach { object in
            deleteObject(object)
        }
    }

    func load<T: Object>(_ object: T) -> [T] {
        if let results = realm?.objects(T.self).toArray(ofType: T.self) {
            return results as [T]
        }
        return []
    }

    func load<T: Object>(_ object: T, filteredBy filter: String) -> [T] {
        if !filter.isEmpty {
            if let results = realm?.objects(T.self).filter(filter).toArray(ofType: T.self) {
                return results as [T]
            }
        }
        return []
    }
}

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0..<count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        return array
    }
}
