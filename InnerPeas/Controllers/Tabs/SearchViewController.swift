//
//  SearchViewController.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 2/13/23.
//

import UIKit

class SearchViewController: UIViewController, UISearchResultsUpdating {

    private let searchVC = UISearchController(searchResultsController: SearchResultsViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        view.backgroundColor = .systemBackground
        (searchVC.searchResultsController as? SearchResultsViewController)?.delegate = self
        searchVC.searchBar.placeholder = "Search..."
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC


    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let resultsVC = searchController.searchResultsController as? SearchViewController,
                let term = searchController.searchBar.text,
              !term.trimmingCharacters(in: .whitespaces).isEmpty else{
            return
        }
        resultsVC.update(with: results)
    }
}

extension SearchViewController: SearchResultsViewControllerDelegate{
    func searchResultsViewController(_ vc: SearchViewController, didSelectResultWith user: User){
        let vc = ProfileViewController(user: user)
        navigationController?.pushViewController(vc, animated: true )
    }
}
