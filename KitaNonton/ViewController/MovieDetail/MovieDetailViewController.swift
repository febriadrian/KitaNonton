//
//  MovieDetailViewController.swift
//  KitaNonton
//
//  Created by Febri Adrian on 26/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var leadingIndicatorConstraint: NSLayoutConstraint!
    @IBOutlet var menuButtons: [UIButton]!
    @IBOutlet weak var topBarsView: UIView!
    @IBOutlet weak var topBarsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var posterTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var posterHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var backdropImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var menuIndicatorWidthConstraint: NSLayoutConstraint!
    
    var viewModel: IMovieDetailViewModel!
    var infoVC: MovieDetailInfoViewController!
    var reviewVC: MovieDetailReviewViewController!
    private var loadingView: LoadingView!

    var topBarsHeight: CGFloat = 0
    var normalViewTopConstraint: CGFloat = 0
    var currentYOffset: CGFloat = 0
    private var shouldShowTopBarsView = false

    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    var viewControllerList: [UIViewController] = []
    var previousMenu: Int = 0
    var selectedIndex: Int = 0
    var screenWidth: CGFloat = 0
    var menuCount: CGFloat = 0
    var indicatorWidth: CGFloat = 0
    var shouldSelectControllerByScroll = true
    var shouldSelectControllerByMenu = true

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageViewController()
        setupComponent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !shouldShowTopBarsView {
            shouldShowTopBarsView = true
        }

        favoriteButton.isSelected = TheFavorite.checkIsFavorite(id: viewModel.movieId)
    }

    private func setupPageViewController() {
        let parameter: [String: Any] = ["id": viewModel.movieId]

        infoVC = MovieDetailInfoInitializer.setup(parameters: parameter) as? MovieDetailInfoViewController
        infoVC.main = self
        infoVC.scrollDelegate = self

        reviewVC = MovieDetailReviewInitializer.setup(parameters: parameter) as? MovieDetailReviewViewController
        reviewVC.main = self
        reviewVC.scrollDelegate = self

        viewControllerList = [infoVC, reviewVC]
        menuCount = CGFloat(viewControllerList.count)
        indicatorWidth = screenWidth / menuCount
        menuIndicatorWidthConstraint.constant = indicatorWidth

        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.setViewControllers(
            [viewControllerList[0]],
            direction: .forward,
            animated: true,
            completion: nil
        )

        guard let pageView = pageViewController.view else { return }
        pageViewController.view?.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pageView)

        NSLayoutConstraint.activate([
            pageView.topAnchor.constraint(equalTo: menuView.bottomAnchor),
            pageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            pageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        addChild(pageViewController)
        pageViewController.didMove(toParent: self)

        for v in pageViewController.view.subviews {
            if v.isKind(of: UIScrollView.self) {
                (v as! UIScrollView).delegate = self as UIScrollViewDelegate
            }
        }
    }

    private func setupComponent() {
        viewModel.delegate = self
        scrollView.delegate = self

        extendedLayoutIncludesOpaqueBars = true
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navBarHeight = navigationController?.navigationBar.frame.height ?? 0

        topBarsHeight = statusBarHeight + navBarHeight
        scrollView.contentInset = UIEdgeInsets(top: -topBarsHeight, left: 0, bottom: 0, right: 0)
        topBarsHeightConstraint.constant = topBarsHeight
        posterTopConstraint.constant += topBarsHeight
        normalViewTopConstraint = posterHeightConstraint.constant + posterTopConstraint.constant + 12
        menuViewTopConstraint.constant = normalViewTopConstraint

        screenWidth = UIScreen.main.bounds.width
        indicatorWidth = screenWidth / CGFloat(menuButtons.count)

        loadingView = LoadingView()
        loadingView.reloadButton.touchUpInside(self, action: #selector(didTapReloadButton))
        loadingView.setup(in: contentView)
        didTapReloadButton()

        favoriteButton.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchUpInside)
    }

    @objc private func didTapReloadButton() {
        loadingView.start { [weak self] in
            self?.viewModel.getMovieDetail()
        }
    }

    @objc private func didTapFavoriteButton() {
        viewModel.updateFavorite()
    }

    private func selectViewController(withIndex index: Int) {
        pageViewController.setViewControllers(
            [viewControllerList[index]],
            direction: previousMenu > index ? .reverse : .forward,
            animated: true,
            completion: nil
        )

        previousMenu = index
    }

    private func selectMenuButtons(withTag tag: Int, completion: (() -> Void)? = nil) {
        menuButtons.forEach { button in
            if button.tag == tag {
                button.isSelected = true
            } else {
                button.isSelected = false
            }

            completion?()
        }
    }

    private func updateIndicatorViewPosition(menu: Int) {
        let constant = indicatorWidth * CGFloat(menu)
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.leadingIndicatorConstraint.constant = constant
                self.view.layoutIfNeeded()
            }) { _ in
                self.shouldSelectControllerByMenu = true
            }
        }
    }

    @IBAction func selectControllerByMenu(_ sender: UIButton) {
        if shouldSelectControllerByMenu {
            shouldSelectControllerByMenu = false
            shouldSelectControllerByScroll = selectedIndex == sender.tag ? true : false
            selectedIndex = sender.tag
            selectViewController(withIndex: sender.tag)
            selectMenuButtons(withTag: sender.tag) {
                self.updateIndicatorViewPosition(menu: sender.tag)
            }
        }
    }
}

extension MovieDetailViewController: MovieDetailDelegate {
    func displayGetMovieDetail(detail: MovieDetailModel.MVDetailModel, trailers: [MovieDetailModel.YoutubeTrailerModel]) {
        loadingView.stop()
        favoriteButton.isSelected = detail.favorite
        posterImage.setImage(with: detail.posterPath)
        backdropImage.setImage(with: detail.backdropPath)
        titleLabel.text = detail.title
        releaseDateLabel.text = detail.releaseDate
        runtimeLabel.text = detail.runtime

        infoVC.detail = detail
        infoVC.trailers = trailers
    }

    func displayGetMovieDetailFailed(message: String) {
        loadingView.stop(isFailed: true, message: message)
    }

    func displayUpdateFavorite(favorite: Bool) {
        favoriteButton.isSelected = favorite
    }
}

extension MovieDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if shouldSelectControllerByScroll {
            let xOffset = scrollView.contentOffset.x
            let increment = CGFloat(selectedIndex) * indicatorWidth
            let constant = ((xOffset - screenWidth) / menuCount) + increment
            guard constant > 0, constant <= screenWidth - indicatorWidth else { return }
            leadingIndicatorConstraint.constant = constant
        }
    }
}

extension MovieDetailViewController: MovieDetailScrollDelegate {
    func didScroll(yOffset: CGFloat) {
        currentYOffset = yOffset

        let constant = normalViewTopConstraint - currentYOffset

        if yOffset > 0 {
            if constant <= topBarsHeight {
                showTopBarsView()
                headerViewTopConstraint.constant = -currentYOffset
                menuViewTopConstraint.constant = topBarsHeight
            } else if constant > topBarsHeight {
                hideTopBarsView()
                headerViewTopConstraint.constant = -currentYOffset
                menuViewTopConstraint.constant = constant
            }
        } else {
            hideTopBarsView()
            headerViewTopConstraint.constant = -currentYOffset
            menuViewTopConstraint.constant = constant
        }
    }

    private func showTopBarsView() {
        guard topBarsView.alpha == 0, shouldShowTopBarsView else { return }
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.title = self.viewModel.movieTitle
                self.topBarsView.alpha = 1
            }
        }
    }

    private func hideTopBarsView() {
        guard topBarsView.alpha == 1 else { return }
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.title = nil
                self.topBarsView.alpha = 0
            }
        }
    }
}

extension MovieDetailViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return viewControllerList.count
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.firstIndex(of: viewController) else { return nil }
        let previousIndex = vcIndex - 1
        guard previousIndex >= 0 else { return nil }
        guard viewControllerList.count > previousIndex else { return nil }
        return viewControllerList[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.firstIndex(of: viewController) else { return nil }
        let nextIndex = vcIndex + 1
        guard viewControllerList.count != nextIndex else { return nil }
        guard viewControllerList.count > nextIndex else { return nil }
        return viewControllerList[nextIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currentViewController = pageViewController.viewControllers?.first,
                let index = viewControllerList.firstIndex(of: currentViewController) {
                if let _ = menuButtons.filter({ $0.tag == index }).first {
                    selectedIndex = index
                    shouldSelectControllerByScroll = true
                    selectViewController(withIndex: index)
                    selectMenuButtons(withTag: index)
                }
            }
        }
    }
}
