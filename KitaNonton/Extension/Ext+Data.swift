//
//  Ext+Data.swift
//  KitaNonton
//
//  Created by Febri Adrian on 25/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

extension Data {
    var toJSON: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let prettyPrintedString = String(data: data, encoding: .utf8) else {
            return nil
        }
        return prettyPrintedString
    }

    var toDictionary: [String: Any]? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []) as? [String: Any] else {
            return nil
        }
        return object
    }
}
