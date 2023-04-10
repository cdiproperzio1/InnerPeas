//
//  SearchViewController.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 2/13/23.
//

import UIKit

class SearchViewController: UIViewController, UISearchResultsUpdating {

    private let searchVC = UISearchController(searchResultsController: SearchResultsViewController())
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout{ index, _ -> NSCollectionLayoutSection? in
            
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.5),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            let fullItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            let thirdItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.33),
                    heightDimension: .fractionalHeight(1)
                )
            )

        
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.5),
                    heightDimension: .fractionalHeight(1)
                ),
                subitem: fullItem,
                count: 2
            )
        
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(160)
            ),
            subitems: [
                item,
                verticalGroup
            ]
        )
        
        let threeItemGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(160)
            ),
            subitem: thirdItem,
            count: 3
        )
            
        let finalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(320)
            ),
            subitems: [
                horizontalGroup,
                threeItemGroup
            ]
        )
        return NSCollectionLayoutSection(group: finalGroup)
    }
    
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

    private var posts = [Post]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        view.backgroundColor = .systemBackground
        (searchVC.searchResultsController as? SearchResultsViewController)?.delegate = self
        searchVC.searchBar.placeholder = "Search..."
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
<<<<<<< HEAD
        view.addSubview(SearchfriendsButton)
        view.addSubview(SearchfollowersButton)
=======
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        fetchData()

>>>>>>> 3e28434937c021fa663385eea4a6582741122445

    }
    
    private func fetchData(){
        DatabaseManager.shared.explorePosts{posts in
            print("\n\n\nPosts: \(posts.count)")
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let resultsVC = searchController.searchResultsController as? SearchResultsViewController,
              let term = searchController.searchBar.text,
              !term.trimmingCharacters(in: .whitespaces).isEmpty else{
            return
        }
        DatabaseManager.shared.searchUsers(with: term) { results in
            DispatchQueue.main.async {
                resultsVC.update(with: results)
            }
        }
        
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            PhotoCollectionViewCell.identifier,
            for: indexPath
        ) as? PhotoCollectionViewCell else {
            fatalError()
        }
        cell.configure(with: UIImage(named: "food"))
        return cell
    }
    
    
    let SearchfriendsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Friends", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    let SearchfollowersButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Followers", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
}

extension SearchViewController: SearchResultsViewControllerDelegate{
    func searchResultsViewController(_ vc: SearchResultsViewController, didSelectResultWith user: User) {
        let vc = ProfileViewController(user: user)
        navigationController?.pushViewController(vc, animated: true )
    }
    

}
