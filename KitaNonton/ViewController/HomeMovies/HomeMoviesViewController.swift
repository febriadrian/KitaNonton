//
//  HomeMoviesViewController.swift
//  KitaNonton
//
//  Created by Febri Adrian on 25/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class HomeMoviesViewController: MoviesCollectionViewController {
    var viewModel: IHomeMoviesViewModel!
    var router: IHomeMoviesRouter!
    private var homeViewController: HomeViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.observeRealmNotification()
        setupComponent()
    }

    private func setupComponent() {
        viewModel.delegate = self
        homeViewController = viewModel.parameters?["homevc"] as? HomeViewController
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homeViewController?.delegate = self

        if viewModel.isInitialLoading {
            loadingView.start { [weak self] in
                self?.viewModel.getMovies()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        homeViewController?.shouldSelectControllerByScroll = true
    }

    override func startRefreshing() {
        viewModel.startRefreshing()
    }

    override func getMovies() {
        viewModel.getMovies()
    }

    override func navToMovieDetail(id: Int) {
        router.navToMovieDetail(id: id)
    }

    override func didScrollToMaxontentOffset() {
        if movies.count > 0, movies.count < viewModel.totalResults, !viewModel.isLoadingMore {
            loadMoreView?.activityIndicator.alpha = 1
            loadMoreView?.activityIndicator.isHidden = false
            viewModel.startLoadMore()
        }
    }

    override func willDisplayCellForItem(indexPath: IndexPath) {
        guard movies.count > 0, movies.count < viewModel.totalResults, indexPath.item == movies.count - 1, !viewModel.isLoadingMore else { return
        }

        loadMoreView?.activityIndicator.alpha = 1
        loadMoreView?.activityIndicator.isHidden = false
        viewModel.startLoadMore()
    }

    override func registerCellType() {
        collectionView.registerCellType(HomeMoviesCollectionViewCell.self)
    }

    override func cellForItemAt(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(HomeMoviesCollectionViewCell.self, for: indexPath)
        let movie = viewModel.movie(at: indexPath.item)
        cell.setupView(movie: movie)
        cell.handleFavorite = { [weak self] favorite in
            TheFavorite.updateFavorite(movie: movie, favorite: favorite) { [weak self] in
                guard let self = self else { return }
                self.movies[indexPath.item].favorite = !favorite
                cell.setupView(movie: self.movies[indexPath.item])
            }
        }
        return cell
    }

    override func sizeForItemAt(indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 180)
    }

    override func referenceSizeForFooter() -> CGSize {
        if viewModel.isLoadingMore == true {
            return CGSize.zero
        }
        return CGSize(width: collectionView.bounds.size.width, height: 30)
    }
}

extension HomeMoviesViewController: HomeMoviesViewModelDelegate {
    func displayGetMovies(result: MoviesResult, movies: [MoviesModel.ViewModel]) {
        displayMovies(result: result, movies: movies)
    }

    func displayUpdateFavorite(movies: [MoviesModel.ViewModel]) {
        self.movies = movies
        collectionView.reloadData()
    }
}

extension HomeMoviesViewController: HomeViewControllerDelegate {
    func scrollToTop() {
        collectionViewScrollToTop()
    }
}
