//
//  MovieDetailInfoViewController.swift
//  KitaNonton
//
//  Created by Febri Adrian on 26/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class MovieDetailInfoViewController: UIViewController {
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var companiesLabel: UILabel!
    @IBOutlet weak var homepageLabel: UILabel!
    @IBOutlet weak var revenueLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var countriesLabel: UILabel!
    @IBOutlet weak var originalTitleLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var trailerView: UIView!
    @IBOutlet weak var trailerCollectionView: UICollectionView!

    var main: MovieDetailViewController?
    var scrollDelegate: MovieDetailScrollDelegate?
    var lastYOffset: CGFloat = 0

    var detail: MovieDetailModel.MVDetailModel? {
        didSet {
            guard let detail = detail else { return }
            genresLabel.text = detail.genres
            overviewLabel.text = detail.overview
            companiesLabel.text = detail.prodCompanies
            countriesLabel.text = detail.prodCountries
            homepageLabel.text = detail.homepage
            revenueLabel.text = detail.revenue
            budgetLabel.text = detail.budget
            originalTitleLabel.text = detail.originalTitle
            taglineLabel.text = detail.tagline
        }
    }

    var trailers: [MovieDetailModel.YoutubeTrailerModel]? {
        didSet {
            guard trailers != nil else { return }
            trailerCollectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponent()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        main?.shouldSelectControllerByScroll = true
    }

    private func setupComponent() {
        scrollView.delegate = self
        trailerCollectionView.delegate = self
        trailerCollectionView.dataSource = self
        trailerCollectionView.registerCellType(TrailerCollectionViewCell.self)

        taglineLabel.font = UIFont.systemFont(ofSize: 16).italic()
        overviewLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(expandOverview)))
    }
    
    @objc private func expandOverview() {
        if overviewLabel.numberOfLines == 0 {
            overviewLabel.numberOfLines = 6
        } else {
            overviewLabel.numberOfLines = 0
        }
    }
}

extension MovieDetailInfoViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trailers?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(TrailerCollectionViewCell.self, for: indexPath)
        guard let trailer = trailers?[indexPath.item] else { return cell }
        cell.setupView(trailer: trailer)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let url = trailers?[indexPath.item].videoUrl else { return }
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 177, height: 118)
    }
}

extension MovieDetailInfoViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let xOffset = scrollView.contentOffset.x
        let yOffset = scrollView.contentOffset.y

        if xOffset == 0 || xOffset != 0, yOffset != 0 {
            lastYOffset = yOffset
        }

        scrollDelegate?.didScroll(yOffset: lastYOffset)
    }
}
