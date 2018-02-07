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

    override func viewDidLoad() {
        view.backgroundColor = .white
        view.addSubview(startSearchButton)

        super.viewDidLoad()

        instanciateSearchResultsController = {
            return SearchResultsViewController()
        }

        searchBarStyle = { searchBar in
            searchBar.tintColor = .blue
            searchBar.barTintColor = .yellow
        }

        // Constraints
        startSearchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startSearchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startSearchButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ])
        
        // Configuration
        startSearchButton.setTitle("Start search", for: .normal)
        startSearchButton.addTarget(self, action: #selector(startSearchAction(_:)), for: .touchUpInside)
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
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
    }
}

extension SearchResultsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        debugPrint("Should display results for: \(String(describing: searchController.searchBar.text))")
    }
}
