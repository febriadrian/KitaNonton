//
//  MovieDetailReviewViewController.swift
//  KitaNonton
//
//  Created by Febri Adrian on 26/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class MovieDetailReviewViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!

    var viewModel: IMovieDetailReviewViewModel!
    var main: MovieDetailViewController?
    var scrollDelegate: MovieDetailScrollDelegate?
    var loadingView: LoadingView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponent()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        main?.shouldSelectControllerByScroll = true
    }

    private func setupComponent() {
        viewModel.delegate = self

        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellType(ReviewTableViewCell.self)

        loadingView = LoadingView()
        loadingView.reloadButton.touchUpInside(self, action: #selector(didTapReloadButton))
        loadingView.setup(in: contentView) {
            self.loadingView.start { [weak self] in
                self?.viewModel.getReviews()
            }
        }
    }

    @objc private func didTapReloadButton() {
        loadingView.start { [weak self] in
            self?.viewModel.getReviews()
        }
    }
}

extension MovieDetailReviewViewController: MovieDetailReviewDelegate {
    func displayGetReviews(result: GeneralResult) {
        switch result {
        case .success:
            loadingView.stop()
            tableView.reloadData()

        case .failure(let message):
            loadingView.stop(isFailed: true, message: message)
        }
    }
}

extension MovieDetailReviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.reviewsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ReviewTableViewCell.self, for: indexPath)
        cell.setupView(review: viewModel.review(at: indexPath.row))
        cell.handleUpdateCell = { [weak self] in
            self?.tableView.beginUpdates()
            self?.tableView.endUpdates()
        }
        return cell
    }
}

extension MovieDetailReviewViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegate?.didScroll(yOffset: scrollView.contentOffset.y)
    }
}
