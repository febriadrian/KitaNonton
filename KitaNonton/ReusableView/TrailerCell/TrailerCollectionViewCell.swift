
//
//  TrailerCollectionViewCell.swift
//  KitaNonton
//
//  Created by Febri Adrian on 26/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class TrailerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImage.layer.cornerRadius = 10
    }

    func setupView(trailer: MovieDetailModel.YoutubeTrailerModel) {
        thumbnailImage.setImage(with: trailer.thumbnailUrl)
    }
}
