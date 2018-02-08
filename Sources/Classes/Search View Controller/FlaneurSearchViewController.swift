//
//  FlaneurSearchViewController.swift
//  FlaneurOpen_Example
//
//  Created by Mickaël Floc'hlay on 07/02/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

/// This class is a convenience wrapper around `UISearchController` that view controllers
/// can subclass to inherit some behaviors.
///
/// ## Why this class?
///
/// If you don't use a `UITableView` or `UINavigationItem`'s `searchController` introduced in iOS 11.0,
/// or any other immediate location for a `UISearchController`'s `searchBar`, and you want to use
/// AutoLayout, things can get weird/hacky/difficult.
///
/// This class fixes all positioning problems found in an app using a navigation controller hierarchy
/// with hidden navigation bars, and using iOS 9.0.
///
/// It will display the search bar right under your view controller's top layout guide.
///
/// ## Subclassing
///
/// To subclass this class, provide your own implementations of `instanciateSearchResultsController`
/// and `searchControllerWillBecomeActive`, and call `startSearchAction` when relevant.
open class FlaneurSearchViewController: UIViewController {
    private let searchBarContainer: UIView = UIView()
    private var searchBarContainerHeightConstraint: NSLayoutConstraint? = nil
    private var searchController: UISearchController?

    /// This property provides the intended search results controller of `UISearchController`.
    /// Please refer to `UISearchController` documentation for details.
    ///
    /// The resulting `UIViewController` will typically implement `UISearchResultsUpdating` and
    /// will act as the `UISearchController`'s `searchResultsUpdater`.
    public var instanciateSearchResultsController: () -> (UIViewController?) = { return nil }

    /// This property can be used as a hook for the subclass to implement some
    /// custom behavior using the search controller, like styling the search bar, get
    /// information about its height, etc.
    public var searchControllerWillBecomeActive: (UISearchController) -> () = { _ in () }

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

    override open func viewWillDisappear(_ animated: Bool) {
        // Dismiss the search before leaving the screen - Cf. #297
        searchController?.isActive = false

        super.viewWillDisappear(animated)
    }

    /// Calls this method when the subclass is ready to show the search bar.
    ///
    /// - Parameter sender: the sender of the action
    @IBAction public func startSearchAction(_ sender: Any? = nil) {
        let searchController = UISearchController(searchResultsController: instanciateSearchResultsController())
        self.searchController = searchController
        if let searchResultsUpdater = searchController.searchResultsController as? UISearchResultsUpdating {
            searchController.searchResultsUpdater = searchResultsUpdater
        }
        searchController.delegate = self
        searchController.searchBar.delegate = self

        searchControllerWillBecomeActive(searchController)

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

