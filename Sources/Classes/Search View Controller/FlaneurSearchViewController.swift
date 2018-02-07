//
//  FlaneurSearchViewController.swift
//  FlaneurOpen_Example
//
//  Created by Mickaël Floc'hlay on 07/02/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

/// TODO
///
/// ## Subclassing
///
/// TODO
open class FlaneurSearchViewController: UIViewController {
    let searchBarContainer: UIView = UIView()
    var searchBarContainerHeightConstraint: NSLayoutConstraint? = nil
    var searchController: UISearchController?

    public var instanciateSearchResultsController: () -> (UIViewController?) = { return nil }
    public var searchBarStyle: (UISearchBar) -> () = { searchBar in () }

    override open func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        // View hierarchy
        view.addSubview(searchBarContainer)

        // Constraints
        searchBarContainer.translatesAutoresizingMaskIntoConstraints = false
        searchBarContainerHeightConstraint = searchBarContainer.heightAnchor.constraint(equalToConstant: 0.0)
        NSLayoutConstraint.activate([
            searchBarContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBarContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBarContainer.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            searchBarContainerHeightConstraint!
            ])
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.navigationController?.setNavigationBarHidden(false, animated: false)
        super.viewWillDisappear(animated)
    }

    @IBAction public func startSearchAction(_ sender: Any? = nil) {
        let searchController = UISearchController(searchResultsController: instanciateSearchResultsController())
        self.searchController = searchController
        if let searchResultsUpdater = searchController.searchResultsController as? UISearchResultsUpdating {
            searchController.searchResultsUpdater = searchResultsUpdater
        }
        searchController.delegate = self
        searchController.searchBar.delegate = self

        searchBarStyle(searchController.searchBar)

        // Add the search bar to the view...
        searchBarContainer.addSubview(searchController.searchBar)
        searchBarContainerHeightConstraint?.constant = searchController.searchBar.frame.height

        searchController.hidesNavigationBarDuringPresentation = false
        // TODO: do something about the height of the status bar?
        self.definesPresentationContext = true

        searchController.searchBar.becomeFirstResponder()
    }
}

extension FlaneurSearchViewController: UISearchControllerDelegate {
    public func willDismissSearchController(_ searchController: UISearchController) {
        view.backgroundColor = .white
        view.alpha = 1.0
        searchBarContainer.removeAllSubviews()
        searchBarContainerHeightConstraint?.constant = 0
        self.searchController = nil
    }

    public func willPresentSearchController(_ searchController: UISearchController) {
        view.backgroundColor = .black
        view.alpha = 0.3
    }
}

extension FlaneurSearchViewController: UISearchBarDelegate {
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

