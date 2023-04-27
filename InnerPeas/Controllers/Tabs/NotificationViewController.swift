//
//  NotificationViewController.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 4/26/23.
//

import UIKit

class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let noActivityLabel: UILabel = {
        let label = UILabel()
        label.text = "No Notifications"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private var viewModels: [NotificationCellType] = []
    private var models: [PeasNotification] = []
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.isHidden = true
        
        table.register(FollowNotificationTableViewCell.self,
                       forCellReuseIdentifier: FollowNotificationTableViewCell.identifier)

        table.register(CommentNotificationTableViewCell.self,
                       forCellReuseIdentifier: CommentNotificationTableViewCell.identifier)
        return table
        
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notifications"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(noActivityLabel)
        fetchNotification()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noActivityLabel.sizeToFit()
        noActivityLabel.center = view.center
    }
    
    private func fetchNotification(){
        NotificationManager.shared.getNotifications { [weak self] models in
            DispatchQueue.main.async {
                self?.models = models
                self?.createViewModels()
            }
        }
    }
    
    private func createViewModels(){
        models.forEach { model in
            guard let type = NotificationManager.PeasType(rawValue: model.notificationType) else {
                return
            }
            let username = model.username
            guard let profilePictureUrl = URL(string: model.profilePictureUrl) else {
                return
            }
            switch type {
                
            case .follow:
                guard let isFollowing = model.isFollowing else {
                    return
                }
                viewModels.append(.follow(viewModel: FollowNotificationCellViewModel(
                    username: username,
                    profilePictureURL: profilePictureUrl,
                    isCurrentUserFollowing: isFollowing,
                    date: model.dateString)
                ))

            case .comment:
                guard let postUrl = URL(string: model.postURL ?? "") else {
                    return
                }
                viewModels.append(.comment(viewModel: CommentNotificationCellViewModel(
                    username: username,
                    profilePictureURL: profilePictureUrl,
                    postURL: postUrl,
                    date: model.dateString)
                ))
            }
        }
        if viewModels.isEmpty {
            noActivityLabel.isHidden = false
            tableView.isHidden = true
        }
        else {
            noActivityLabel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = viewModels[indexPath.row]

        switch cellType {
        case .follow(let viewModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: FollowNotificationTableViewCell.identifier,
                for: indexPath
            ) as? FollowNotificationTableViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            cell.delegate = self
            return cell
        case .comment(let viewModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CommentNotificationTableViewCell.identifier,
                for: indexPath
            ) as? CommentNotificationTableViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellType = viewModels[indexPath.row]
        let username: String
        switch cellType {
        case .follow(let viewModel):
            username = viewModel.username
        case .comment(let viewModel):
            username = viewModel.username
        }
        
        DatabaseManager.shared.findUser(username: username) { [weak self] user in
            guard let user = user else {
                return
            }
            DispatchQueue.main.async {
                let vc = ProfileViewController(user: user)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}

extension NotificationViewController: FollowNotificationTableViewCellDelegate, CommentNotificationTableViewCellDelegate{
    
    func followNotificationTableViewCell(
        _ cell: FollowNotificationTableViewCell,
        didTapButton isFollowing: Bool,
        viewModel: FollowNotificationCellViewModel
    ) {
        let username = viewModel.username
        DatabaseManager.shared.updateRelationship(
            state: isFollowing ? .follow : .unfollow,
            for: username
        ){
            [weak self] success in
            if !success {
                DispatchQueue.main.async {
                    let alert = UIAlertController(
                        title: "Something went wrong",
                        message: "Unable to perfotm action",
                        preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(
                        title: "Dissmiss",
                        style: .cancel,
                        handler: nil))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    func commentNotificationTableViewCell(
        _cell: CommentNotificationTableViewCell,
        didTapPostWith viewModel: CommentNotificationCellViewModel
    ) {
        
        guard let index = viewModels.firstIndex(where: {
            switch $0 {
            case .follow:
                return false
            case .comment(let current):
                return current == viewModel
            }
        }) else {
            return
        }
        openPost(with: index, username: viewModel.username)
    }
    
    func openPost(with index: Int, username: String){
        print(index)
        
        guard index < models.count else {
            return
        }
        let model = models[index]
        let username = username
        guard let postID = model.postID else {
            return
        }
        
        DatabaseManager.shared.getPost(
            with: postID,
            from: username
        ) { [weak self] post in
            DispatchQueue.main.async {
                guard let post = post else {
                    let alert = UIAlertController(
                        title: "Oops",
                        message: "Unable to open this file",
                        preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil ))
                    self?.present(alert, animated: true)
                    return
                }
                
                let vc = PostViewController(post: post)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}


//private func mockData(){
//        tableView.isHidden = false
//        guard let postUrl = URL(string: "https://media.istockphoto.com/id/1400292359/photo/ice-cream-cones-bouquet.jpg?b=1&s=170667a&w=0&k=20&c=WWRPlrH9XrlZ74wkUhiK5S6nzm9O0vjRDpSJ-CHAC70=")
//        else{
//            return
//        }
//        guard let iconUrl = URL(string: "https://cdn.pixabay.com/photo/2016/03/28/12/35/cat-1285634__480.png")
//        else{
//            return
//        }
//
//        viewModels = [
//            .follow(
//                viewModel: FollowNotificationCellViewModel(
//                    username: "Niashaly",
//                    profilePictureURL: iconUrl,
//                    isCurrentUserFollowing: true
//                )
//            ),
//
//                .comment(
//                    viewModel: CommentNotificationCellViewModel(
//                        username: "Niashaly",
//                        profilePictureURL: iconUrl,
//                        postURL: postUrl
//                    )
//                )
//        ]
//
//        tableView.reloadData()
//
//    }
