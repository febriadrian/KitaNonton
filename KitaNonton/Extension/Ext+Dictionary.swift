//
//  Ext+Dictionary.swift
//  KitaNonton
//
//  Created by Febri Adrian on 25/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

extension Dictionary {
    var toData: Data? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else {
            return nil
        }
        return data
    }
    
    var toJSON: String? {
        guard let data = toData else { return nil }
        let jsonString = String(data: data, encoding: .utf8)
        return jsonString
    }
}
