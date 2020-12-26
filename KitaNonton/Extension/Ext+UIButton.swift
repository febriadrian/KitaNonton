//
//  Ext+UIButton.swift
//  KitaNonton
//
//  Created by Febri Adrian on 25/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

extension UIButton {
    func touchUpInside(_ target: Any?, action: Selector) {
        addTarget(target, action: action, for: .touchUpInside)
    }
}
