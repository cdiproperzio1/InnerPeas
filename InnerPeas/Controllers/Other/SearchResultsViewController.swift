//
//  SearchResultsViewController.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 3/22/23.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewController(_ vc: SearchViewController, didSelectResultWith user: User)
}

class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    public weak var delegate:  SearchResultsViewControllerDelegate?
    
    private var users = [User]()
    
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    public func update(with: results: [Users]){
        self.users = results
        tableView.reloadData()
        if users.isEmpty {
            tableView.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].username
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.searchResultsViewController(self, didSelectResultWith: user.[indexPath.row])
    }
    

}
