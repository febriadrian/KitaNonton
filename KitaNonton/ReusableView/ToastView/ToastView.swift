//
//  ToastView.swift
//  KitaNonton
//
//  Created by Febri Adrian on 25/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class ToastView: CustomXIBView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var messageLabel: UILabel!

    override func setupComponent() {
        contentView.fixInView(self)
    }
}
