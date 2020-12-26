//
//  HomeViewController.swift
//  KitaNonton
//
//  Created by Febri Adrian on 25/12/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

protocol HomeViewControllerDelegate {
    func scrollToTop()
}

class HomeViewController: UIViewController {
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var leadingIndicatorConstraint: NSLayoutConstraint!
    @IBOutlet var menuButtons: [UIButton]!

    var viewModel: IHomeViewModel!
    var mainViewController: MainViewController?
    var delegate: HomeViewControllerDelegate?
    var popularVC: HomeMoviesViewController!
    var playingVC: HomeMoviesViewController!
    var upcomingVC: HomeMoviesViewController!
    var topRatedVC: HomeMoviesViewController!

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
        setupComponent()
        setupPageViewController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainViewController?.mainViewControllerDelegate = self
    }

    private func setupComponent() {
        navigationItem.titleView = UIImageView(image: UIImage(named: "tmdblogo"))
        screenWidth = UIScreen.main.bounds.width

        mainViewController = viewModel.parameters?["mainvc"] as? MainViewController
        mainViewController?.mainViewControllerDelegate = self
    }

    private func setupPageViewController() {
        popularVC = HomeMoviesInitializer.setup(
            parameters: getParameters(for: .popular)
        ) as? HomeMoviesViewController

        playingVC = HomeMoviesInitializer.setup(
            parameters: getParameters(for: .playing)
        ) as? HomeMoviesViewController

        upcomingVC = HomeMoviesInitializer.setup(
            parameters: getParameters(for: .upcoming)
        ) as? HomeMoviesViewController

        topRatedVC = HomeMoviesInitializer.setup(
            parameters: getParameters(for: .toprated)
        ) as? HomeMoviesViewController

        viewControllerList = [popularVC, playingVC, upcomingVC, topRatedVC]
        menuCount = CGFloat(viewControllerList.count)
        indicatorWidth = screenWidth / menuCount

        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.setViewControllers(
            [viewControllerList[0]],
            direction: .forward,
            animated: true,
            completion: nil
        )

        guard let pageView = pageViewController.view else { return }
        pageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageView)

        NSLayoutConstraint.activate([
            pageView.topAnchor.constraint(equalTo: menuView.bottomAnchor),
            pageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        addChild(pageViewController)
        pageViewController.didMove(toParent: self)

        for v in pageViewController.view.subviews {
            if v.isKind(of: UIScrollView.self) {
                (v as! UIScrollView).delegate = self as UIScrollViewDelegate
            }
        }
    }

    private func selectViewController(withIndex index: Int) {
        let viewController = viewControllerList[index]

        pageViewController.setViewControllers(
            [viewController],
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

    private func getParameters(for category: MovieCategory) -> [String: Any] {
        return [
            "homevc": self,
            "category": category
        ]
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

extension HomeViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
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

extension HomeViewController: UIScrollViewDelegate {
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

extension HomeViewController: MainViewControllerDelegate {
    func scrollToTop() {
        delegate?.scrollToTop()
    }
}
