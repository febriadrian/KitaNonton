//
//  Ext+UIFont.swift
//  KitaNonton
//
//  Created by Febri Adrian on 24/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

extension UIFont {
    private func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0)
    }

    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}
