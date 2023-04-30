//
//  ListViewController.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 4/29/23.
//

import UIKit


final class ListViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(ListUserTableViewCell.self, forCellReuseIdentifier: ListUserTableViewCell.identifier)

        return tableView
    }()
    
    
    enum ListType{
        case followers(user: User)
        case following(user: User)
        
        var title: String {
            switch self {
            case .followers:
                return "Followers"
            case .following:
                return "Following"
            }
        }
    }
    
    let type: ListType
    private var viewModels: [ListUserTableViewCellViewModel] = []
    
    init(type: ListType){
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        title = type.title
        tableView.delegate = self
        tableView.dataSource = self
        configureViewModels()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureViewModels(){
        switch type {
        case .followers(let targetUser):
            DatabaseManager.shared.followers(for: targetUser.username) {[weak self] usernames in
                self?.viewModels = usernames.compactMap({
                    ListUserTableViewCellViewModel(imageURL: nil, usernmae: $0)
                })
                DispatchQueue.main.async{
                    self?.tableView.reloadData()
                }

            }
        case .following(let targetUser):
            DatabaseManager.shared.following(for: targetUser.username) {[weak self] usernames in
                self?.viewModels = usernames.compactMap({
                    ListUserTableViewCellViewModel(imageURL: nil, usernmae: $0)
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }

            }
        }
    }
  

}

extension ListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListUserTableViewCell.identifier, for: indexPath) as? ListUserTableViewCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let username = viewModels[indexPath.row].usernmae
        DatabaseManager.shared.findUser(username: username) { [weak self] user in
            if let user = user {
                DispatchQueue.main.async {
                    let vc = ProfileViewController(user: user)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
