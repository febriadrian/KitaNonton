//
//  FavoriteMoviesViewController.swift
//  KitaNonton
//
//  Created by Febri Adrian on 26/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class FavoriteMoviesViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!

    var viewModel: IFavoriteMoviesViewModel!
    var router: IFavoriteMoviesRouter!
    private var refreshControl: UIRefreshControl!
    private var loadingView: LoadingView!
    private var mainViewController: MainViewController?
    private var movies: [MoviesModel.ViewModel] = []
    private var delegateCanScrollToTop = false

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.observeRealmNotification()
        setupComponent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainViewController?.mainViewControllerDelegate = self
        viewModel.getMovies()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegateCanScrollToTop = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegateCanScrollToTop = false
    }

    private func setupComponent() {
        title = "Favorites"

        viewModel.delegate = self

        mainViewController = viewModel.parameters?["mainvc"] as? MainViewController
        mainViewController?.mainViewControllerDelegate = self

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCellType(HomeMoviesCollectionViewCell.self)
        collectionView.refreshControl = refreshControl

        loadingView = LoadingView()
        loadingView.reloadButton.touchUpInside(self, action: #selector(didTapReloadButton))
        loadingView.setup(in: contentView)
        loadingView.reloadButton.setTitle("Discover Movies", for: .normal)
    }

    private func checkCurrentFavoriteMovies() {
        if movies.count == 0 {
            loadingView.start { [weak self] in
                self?.viewModel.getMovies()
            }
        }
    }

    @objc private func didTapReloadButton() {
        mainViewController?.selectedIndex = 0
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            UIApplication.shared.topMostViewController()?.dismiss()
        }
    }
}

extension FavoriteMoviesViewController: FavoriteMoviesViewModelDelegate {
    func displayMovies(movies: [MoviesModel.ViewModel]) {
        self.movies = movies
        collectionView.reloadData()

        if movies.count == 0 {
            loadingView.stop(isFailed: true, message: Messages.noFavoriteMovies)
        } else {
            loadingView.stop()
        }
    }

    func displayUpdateFavorite(movies: [MoviesModel.ViewModel]) {
        checkCurrentFavoriteMovies()
    }
}

extension FavoriteMoviesViewController: MainViewControllerDelegate {
    func scrollToTop() {
        guard collectionView.numberOfItems(inSection: 0) > 2, delegateCanScrollToTop else { return }
        collectionView.scrollToItem(at: [0, 0], at: .bottom, animated: true)
    }
}

extension FavoriteMoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(HomeMoviesCollectionViewCell.self, for: indexPath)
        cell.setupView(movie: movies[indexPath.item])
        cell.handleFavorite = { [weak self] favorite in
            guard let movie = self?.movies[indexPath.item], favorite else { return }

            TheFavorite.updateFavorite(movie: movie, favorite: favorite) { [weak self] in
                guard let self = self else { return }
                collectionView.performBatchUpdates({
                    self.movies.remove(at: indexPath.item)
                    collectionView.deleteItems(at: [indexPath])
                })
                self.checkCurrentFavoriteMovies()
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = movies[indexPath.item].id
        router?.navToMovieDetail(id: id)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 180)
    }
}
