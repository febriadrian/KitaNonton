//
//  ErrorResponse.swift
//  KitaNonton
//
//  Created by Febri Adrian on 25/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Foundation

struct ErrorResponse: Codable {
    let message: String?
    let code: Int?
    
    enum CodingKeys: String, CodingKey {
        case message = "status_message"
        case code = "status_code"
    }
}
