//
//  ViewController.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 2/1/23.
//

import Firebase
import FirebaseAuth
import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var collectionView: UICollectionView? = nil
    
    private var viewModels = [[HomeFeedCellType]()]
    private var posts = [Post]()
    private var observer: NSObjectProtocol?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "InnerPeas"
        view.backgroundColor = .systemBackground
        configureCollectionView()
        fetchPost()
        
        observer = NotificationCenter.default.addObserver(forName: .didPostNotification, object: nil, queue: .main, using: { [weak self] _ in
            self?.viewModels.removeAll()
            self?.fetchPost()
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    private func fetchPost(){
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        let userGroup = DispatchGroup()
        userGroup.enter()
        var allPosts: [(post: Post, owner: String)] = []
        
        DatabaseManager.shared.following(for: username) { usernames in
            defer {
                userGroup.leave()
            }
            let users = usernames + [username]
            for current in users {
                userGroup.enter()
                DatabaseManager.shared.posts(for: current) { result in
                    DispatchQueue.main.async {
                        defer {
                            userGroup.leave()
                        }
                        switch result {
                        case .success(let posts):
                            allPosts.append(contentsOf: posts.compactMap({
                                (post: $0, owner: current)
                            }))
                            self.posts.append(contentsOf: posts)
                        case .failure(let error):
                            break
                            
                        }
                    }
                }
            }
        }
        userGroup.notify(queue: .main){
            let sorted = allPosts.sorted(by: {
                return $0.post.date < $1.post.date
            })
            let group = DispatchGroup()
            sorted.forEach{ model in
                group.enter()
                self.createViewModel(
                    model: model.post,
                    username: model.owner,
                    completion: {success in
                    defer {
                        group.leave()
                    }
                    if !success {
                        print("\n\n\n failed to create")
                    
                    }
                }
                )
            }

            group.notify(queue: .main) {
                self.collectionView?.reloadData()
            }
        }
    }
    
    private func createViewModel(model: Post, username: String, completion: @escaping (Bool) -> Void){
            
        StorageManager.shared.profilePictureURL(for: username) { [weak self] profilePictureURL in
            guard let profilePhotoURL = profilePictureURL else {return}
            guard let postURL = model.postURLs.first else {return}
            
            let postData: [HomeFeedCellType] =
            [
                .poster(
                    viewModel: PosterCollectionViewCell(
                        username: username,
                        profilePictureURL: profilePhotoURL
              
                    )
                ),
                .post(
                    viewModel: PostCollectionViewCell(
                        postUrl: URL(string: postURL)!
                    )
                ),
                
                .postDescription(
                    viewModel: PostDescriptionCollectionViewCell(
                        name: model.title,
                        isMade: false,
                        isFav: false
                    )
                ),
                
                .postRating(
                    viewModel: PostRatingCollectionViewCell(
                        averageRating: 3
                    )
                ),
                
                .thumbNails(viewModel: ThumbnailsCollectionViewCell())
                
            ]
            self?.viewModels.append(postData)
            completion(true)
        }
            
        
        
    }
    
    func configureCollectionView(){
        //post+action+average ratings+commentItem
        let height:CGFloat = 60 + 50 + 20 + 55 + view.width
        let collectionView = UICollectionView(frame: .zero,
                         collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { index, _ -> NSCollectionLayoutSection? in

            //Items
            //poster
            let poster = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(60)
                )
            )
            //post
            let post = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(1)
                )
            )
            //postDescription
            let postDescription = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(50)
                )
            )
            
            //average ratings
            let averageRating = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(20)
                )
            )
            
            //thumbNailImages
            let thumbNailImages = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(55)
                )
            )


            //Groups - poster, post, actions(favorite, created, comments, average rating)....
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(height)
                ),
                subitems: [
                    poster,
                    post,
                    postDescription,
                    averageRating,
                    thumbNailImages,
                ])

            //Sections
            let section =  NSCollectionLayoutSection(group: group)
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 0, bottom: 20, trailing: 0)
            return section
        })
       )
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(
            PosterCollectionViewCellType.self,
            forCellWithReuseIdentifier: PosterCollectionViewCellType.identifier
        )
        collectionView.register(
            PostCollectionViewCellType.self,
            forCellWithReuseIdentifier: PostCollectionViewCellType.identifier
        )
        collectionView.register(
            PostDescriptionCollectionViewCellType.self,
            forCellWithReuseIdentifier: PostDescriptionCollectionViewCellType.identifier
        )
        collectionView.register(
            PostRatingCollectionViewCellType.self,
            forCellWithReuseIdentifier: PostRatingCollectionViewCellType.identifier
        )
        collectionView.register(
            ThumbnailsCollectionViewCellType.self,
            forCellWithReuseIdentifier: ThumbnailsCollectionViewCellType.identifier
        )
        
        self.collectionView = collectionView
    }
    
    //collections to hold items in frame
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels[section].count
    }
    
    let colors: [UIColor] = [.systemMint, .green, .blue, .systemGray, .orange,]
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cellType = viewModels[indexPath.section][indexPath.row]
        
        switch cellType{
            
        //WHERE INFO IS LOADED INTO THE CELL
        case .poster(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PosterCollectionViewCellType.identifier,
                for: indexPath
            ) as? PosterCollectionViewCellType else{
                fatalError()
            }
            cell.delegate = self
            cell.configure(with:viewModel)
            return cell
            
        case .post(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostCollectionViewCellType.identifier,
                for: indexPath
            ) as? PostCollectionViewCellType else{
                fatalError()
            }
            cell.configure(with:viewModel)
            cell.contentView.backgroundColor = colors[indexPath.row]
            return cell
            
        case .postDescription(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostDescriptionCollectionViewCellType.identifier,
                for: indexPath
            ) as? PostDescriptionCollectionViewCellType else{
                fatalError()
            }
            cell.delegate = self
            cell.configure(with:viewModel)
            return cell
            
        case .postRating(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostRatingCollectionViewCellType.identifier,
                for: indexPath
            ) as? PostRatingCollectionViewCellType else{
                fatalError()
            }
            cell.configure(with:viewModel)
            //cell.contentView.backgroundColor = colors[indexPath.row]
            return cell
            
        case .thumbNails(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ThumbnailsCollectionViewCellType.identifier,
                for: indexPath
            ) as? ThumbnailsCollectionViewCellType else{
                fatalError()
            }
            cell.configure(with:viewModel)
            //cell.contentView.backgroundColor = colors[indexPath.row]
            return cell
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModels.count
    }
    
}


extension HomeViewController: PosterCollectionViewCellTypeDelegate{
    func PosterCollectionViewCellTypeDidTapUsername(_cell: PosterCollectionViewCellType){
        print("tapped username")
        //let vc = ProfileViewController(user:)
        
    }
    func PosterCollectionViewCellTypeDidTapMoreButton(_cell: PosterCollectionViewCellType){
        print("tapped more")
        let sheet = UIAlertController(title: "Actions",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: nil))
        
        sheet.addAction(UIAlertAction(title: "Report",
                                      style: .destructive,
                                      handler: {_ in}))
        
        sheet.addAction(UIAlertAction(title: "Block",
                                      style: .destructive,
                                      handler: {_ in} ))
        
        sheet.addAction(UIAlertAction(title: "Not Interested",
                                      style: .destructive,
                                      handler: {_ in} ))
        present(sheet, animated: true)
    }

}

extension HomeViewController: ThumbnailsCollectionViewCellTypeDelegate{
    func ThumbnailsCollectionViewCellTypeDidTapRecipeLabel(_cell: ThumbnailsCollectionViewCellType) {
        let vc = RecipeViewController()
        navigationController?.pushViewController(vc, animated: true)
        print("Tapped Bottom recipe")
        
    }

}
extension HomeViewController: PostDescriptionCollectionViewCellTypeDelegate{

    func PostDesciptionCollectionViewCellTypeDidTapRecipeName(_cell: PostDescriptionCollectionViewCellType) {
        let vc = RecipeViewController()
        vc.title = "TEST"
        navigationController?.pushViewController(vc, animated: true)
        print("Tapped recipe")
    }
    
    func PostDescriptionCollectionViewCellTypeDidTapisMade(_cell: PostDescriptionCollectionViewCellType, isMade: Bool) {
        print("Tapped is made")
    }
    
    func PostDescriptionCollectionViewCellTypeDidTapisFav(_cell: PostDescriptionCollectionViewCellType, isFav: Bool) {
        print("Tapped is Fav")
    }
    
    func PostDescriptionCollectionViewCellTypeDidTapComment(_cell: PostDescriptionCollectionViewCellType) {
        
        let vc = CommentViewController(post: posts[0])
        vc.title = "Comments"
        navigationController?.pushViewController(vc, animated: true)
        }
    
    func loadData(){
        
    }
        
    }


    


