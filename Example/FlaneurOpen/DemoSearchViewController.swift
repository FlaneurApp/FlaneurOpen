//
//  DemoSearchViewController.swift
//  FlaneurOpen_Example
//
//  Created by Mickaël Floc'hlay on 07/02/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import FlaneurOpen

final class DemoSearchViewController: FlaneurSearchViewController {
    let startSearchButton = UIButton(type: .system)
    let dismissButton = UIButton(type: .system)

    override func viewDidLoad() {
        view.backgroundColor = .white
        view.addSubview(startSearchButton)
        view.addSubview(dismissButton)

        super.viewDidLoad()

        instanciateSearchResultsController = {
            return SearchResultsViewController()
        }

        searchControllerWillBecomeActive = { searchController in
            guard let searchResultsViewController = searchController.searchResultsController as? SearchResultsViewController else {
                fatalError("Unexpected view controller type")
            }

            searchResultsViewController.searchBarHeight = searchController.searchBar.frame.height
        }

        // Constraints
        startSearchButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startSearchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startSearchButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            dismissButton.centerXAnchor.constraint(equalTo: startSearchButton.centerXAnchor),
            dismissButton.centerYAnchor.constraint(equalTo: startSearchButton.centerYAnchor, constant: 24.0)
            ])
        
        // Configuration
        startSearchButton.setTitle("Start search", for: .normal)
        startSearchButton.addTarget(self, action: #selector(startSearchAction(_:)), for: .touchUpInside)

        dismissButton.setTitle("Dismiss", for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissAction(_:)), for: .touchUpInside)
    }

    @IBAction func dismissAction(_ sender: Any?) {
        self.navigationController?.popViewController(animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.navigationController?.setNavigationBarHidden(false, animated: false)
        super.viewWillDisappear(animated)
    }
}

final class SearchResultsViewController: UIViewController {
    let neverHiddenByKeyboardView = UIImageView(image: UIImage(named: "radial-gradient"))

    var searchBarHeight: CGFloat = 0.0 {
        didSet {
            guard let topConstraint = topConstraint else { return }
            topConstraint.constant = searchBarHeight + 1.0
            view.layoutIfNeeded()
        }
    }
    private var topConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    private var keyboardObserver: KeyboardObserver?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(neverHiddenByKeyboardView)
        neverHiddenByKeyboardView.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = neverHiddenByKeyboardView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: searchBarHeight + 1.0)
        bottomConstraint = neverHiddenByKeyboardView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -1.0)

        guard let topConstraint = self.topConstraint,
            let bottomConstraint = self.bottomConstraint else {
                fatalError("Unexpected nil constraints")
        }

        NSLayoutConstraint.activate([
            neverHiddenByKeyboardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 1.0),
            neverHiddenByKeyboardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -1.0),
            topConstraint,
            bottomConstraint
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        self.keyboardObserver = KeyboardObserver() { [weak self] keyboardHeight in
            self?.bottomConstraint?.constant = -keyboardHeight - 1.0
            self?.view.layoutIfNeeded()
        }
    }
}

extension SearchResultsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        debugPrint("Should display results for: \(String(describing: searchController.searchBar.text))")
    }
}
