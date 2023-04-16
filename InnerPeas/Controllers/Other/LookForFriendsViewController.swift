//
//  LookForFriendsViewController.swift
//  InnerPeas
//
//  Created by Anaya Potter on 3/28/23.
//

import UIKit


class LookForFriendsViewController: UIViewController, UISearchResultsUpdating {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Looking for friends..."
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        // Do any additional setup after loading the view.
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
    }
}
