//
//  Helper.swift
//  KitaNonton
//
//  Created by Febri Adrian on 24/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation
import UIKit

struct Helper {
    static func arrayToString(_ array: [Any]?) -> String? {
        var string: String?
        if let array = array {
            for x in array {
                if string == nil {
                    string = "\(x)"
                } else {
                    string = string! + ", " + "\(x)"
                }
            }
        }
        return string ?? nil
    }

    static func dateFormatter(_ dateString: String?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dateString ?? "") {
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let date = dateFormatter.string(from: date)
            return "Release on \(date)"
        }
        return "Release on n/a"
    }

    static func currencyFormatter(price: Int?) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "en_US")
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter.string(from: NSNumber(value: price ?? 0)) ?? "n/a"
    }
}

public func TRACER(_ data: String? = nil) {
    var separator: String {
        var s = ""
        for _ in 0...69 {
            s.append("=")
        }
        return s
    }

    let trace = """
    \(separator)
    
    \(data == nil ? "NO RESULT" : data!)
    
    \(separator)
    """

    print(trace)
}
