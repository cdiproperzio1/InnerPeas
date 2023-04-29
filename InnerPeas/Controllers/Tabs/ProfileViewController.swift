//
//  ProfileViewController.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 2/13/23.
//
import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase


class ProfileViewController: UIViewController{
    
    private var collectionView:UICollectionView?
    private var viewModels = [[HomeFeedCellType]()]
    let User = Auth.auth().currentUser
    private var headerViewModel: ProfileHeaderViewModel?
    
    
    
    let userInfo=UILabel(frame: CGRect(x: 50, y: 150, width: 125, height: 200))
    private let user: User
    var firstView:Int=300
    var posts = [Post]()
    var recipesCount:UILabel?
    
    
    
    private var isCurrentUser: Bool {
        
        return user.username.lowercased() == UserDefaults.standard.string(forKey: "username")?.lowercased() ?? ""
    }
    
    init(user: User){
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    //private let containerView = ProfileHeaderView()
    
    //declare lazy when adding things to something. Doesn't render until called.
//    lazy var containerView: UIView = {
//        let view = UIView()
//        //view.backgroundColor = .systemBackground
//        userInfo.font = UIFont.systemFont(ofSize: 16)
//        //userInfo.textColor = .secondaryLabel
//        view.addSubview(userInfo)
//
//        self.recipesCount=UILabel(frame: CGRect(x: self.view.frame.width-100, y: 100, width: 40, height: 40))
//        self.recipesCount!.font = UIFont.systemFont(ofSize: 14.0)
//        //self.recipesCount!.textColor = .blue
//        view.addSubview(self.recipesCount!)
//
//        configure()
//
//        let buttonWidth: CGFloat = (view.width-10)/3
//        view.addSubview(friendsButton)
//        friendsButton.anchor(right: view.rightAnchor, paddingRight: 170, width: 70, height: 200)
//        //friendsButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: view.height/2)
//
//        //view.addSubview(followButton)
//        //followButton.anchor(top: view.topAnchor, right: view.rightAnchor, paddingTop: 5, width: 150, height: 100)
//
//        view.addSubview(followersButton)
//        followersButton.anchor(right: view.rightAnchor, paddingRight: 100, width: 70, height: 200)
//
//        view.addSubview(recipesLabel)
//        recipesLabel.anchor(right: view.rightAnchor, paddingRight: 30, width: 70, height: 200)
//
//
//        view.addSubview(profileImageView)
//        profileImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        profileImageView.anchor(left: view.leftAnchor, paddingLeft: 32, width: 120, height: 120)
//        profileImageView.layer.cornerRadius = 120 / 2
//        profileImageView.layer.borderWidth = 1.0
//        profileImageView.layer.masksToBounds = true
//
//        profileImageView.layer.borderColor = UIColor.white.cgColor
//        profileImageView.clipsToBounds = true
//        return view
//    }()
    
//    let profileImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.clipsToBounds = true
//        imageView.layer.masksToBounds = true
//        imageView.contentMode = .scaleAspectFill
//        return imageView
//    }()
//
//    let friendsButton: UIButton = {
//        let button = UIButton()
//        button.setTitleColor(.label, for: .normal)
//        button.setTitle("Friends", for: .normal)
//        button.titleLabel?.numberOfLines = 2
//        button.layer.cornerRadius = 4
//        button.layer.borderWidth = 0.5
//        //button.layer.borderColor = UIColor.tertiaryLabel.cgColor
//        button.titleLabel!.font = UIFont.systemFont(ofSize: 14.0)
//        return button
//    }()
//
//    let followersButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Followers", for: .normal)
//        button.setTitleColor(.label, for: .normal)
//        button.titleLabel?.numberOfLines = 2
//        button.layer.cornerRadius = 4
//        button.layer.borderWidth = 0.5
//        //ffrttgv button.layer.borderColor = UIColor.tertiaryLabel.cgColor
//        button.titleLabel!.font = UIFont.systemFont(ofSize: 14.0)
//        return button
//    }()
//
//    let recipesLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 14.0)
//        label.text = "Recipes"
//        label.tintColor = .label
//        return label
//    }()
//
//    //follow button
//    let followButton: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = .systemBlue
//        button.setTitle("Follow", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        return button
//    }()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = user.username.uppercased()
        view.backgroundColor = .systemBackground
        configureCollectionView()
        configure()
        fetchUserInfo()
        //view.addSubview(containerView)
        
        userInfo.lineBreakMode = .byWordWrapping
        userInfo.numberOfLines = 0
        view.backgroundColor = .systemBackground
        
        
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
//        layout.itemSize = CGSize(width: 110, height: 110)
//        print(firstView)
//
//
//        let frame = CGRect(x:10, y: firstView + 10, width: Int(self.view.frame.width)-20, height: Int(self.view.frame.height)-firstView)
//
//
//        self.collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
//
//        collectionView?.register(
//            ProfileHeaderCollectionReusableView.self,
//            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
//            withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier)
//
//        collectionView!.backgroundColor = .systemBackground
//        collectionView?.register(PhotoCollectionViewCell.self,
//                                 forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
//        collectionView?.dataSource = self
//        collectionView?.delegate = self
//        collectionView?.alwaysBounceVertical = true
//        collectionView?.bounces = true
//        view.addSubview(collectionView!)
        
        
//
//        guard let username = UserDefaults.standard.string(forKey: "username") else {
//            return
//        }
//
//        Database.database().reference().child("Users/\(username)").getData(completion:  { error, snapshot in
//            guard error == nil else {
//                print(error!.localizedDescription)
//                return;
//            }
//            guard let dictionary = snapshot!.value as? [String: Any] else {return}
//
//            guard let bio = dictionary["bio"] else { return}
//            guard let fname = dictionary["firstName"] else {return}
//            guard let lname = dictionary["lastName"] else {return}
//            guard let location = dictionary["location"] else {return}
//
//            self.userInfo.text="\(fname) \(lname) \n\(bio) \nLocation: \(location)"
//        });
//
//        Database.database().reference().child("Users/\(username)/Posts").getData(completion:  { error, snapshot in
//            guard error == nil else {
//                print(error!.localizedDescription)
//                return;
//            }
//            guard let dictionary = snapshot!.value as? [String: Any] else {return}
//            for (key, data) in dictionary {
//                if let data = data as? [String: Any] {
//                    var postData = data
//                    postData["id"] = key
//                    if let post = Post(with: postData) {
//                        self.posts.append(post)
//                    }
//                }
//            }
//            self.collectionView?.reloadData()
//
//        });
        
//        let pathReference = Storage.storage().reference(withPath: "\(username)/profile_picture.png")
//        pathReference.getData(maxSize: 1 * 2048 * 2048) { data, error in
//            if let error = error {
//                print(error)
//                // Uh-oh, an error occurred!
//            } else {
//                // Data for "images/island.jpg" is returned
//                let myImage = UIImage(data: data!)
//                self.profileImageView.image=myImage
//
//            }
//        }
//        view.addSubview(containerView)
//        containerView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 300)
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    private func fetchUserInfo() {
        let group = DispatchGroup()
        let username = user.username
        
        //get the post for the users profile
        group.enter()
        DatabaseManager.shared.posts(for: username) { [weak self] result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let posts):
                self?.posts = posts
            case .failure:
                break
            }
        }
        
        //get the user info for that profile
        var profilePictureURL: URL?
        var buttonType: ProfileButtonType = .edit
        var followers = 0
        var following = 0
        var recipes = 0
        var name: String?
        var bio: String?
        var location: String?

        //get counts of followers, following, recipe
        group.enter()
        DatabaseManager.shared.getUserCounts(username: user.username) { result in
            defer {
                group.leave()
            }
            recipes = result.recipe
            followers = result.followers
            following = result.following
            
        }
        
        //get name, bio
        DatabaseManager.shared.getUserInfo(username: user.username){ User in
            var fname = User?.firstName
            var lname = User?.lastName
            bio = User?.bio
            location = User?.location
            
            if let fname = User?.firstName, let lname = User?.lastName
            {
                name = "\(fname) \(lname)"
            } else if let fname = User?.firstName {
                name = fname
            } else if let lname = User?.lastName {
                name = lname
            } else {
                name = "Unknown"
            }

        }
        
        //get profile image
        group.enter()
        StorageManager.shared.profilePictureURL(for: user.username) { url in
            defer {
                group.leave()
            }
            profilePictureURL = url
        }
        
        //if profile is not current user
        if !isCurrentUser {
            group.enter()
            DatabaseManager.shared.isFollowing(targetUsername: user.username) { isFollowing in
                defer {
                    group.leave()
                }
                buttonType = .follow(isFollowing: isFollowing)
            }
        }
        
        group.notify(queue: .main){
            self.headerViewModel = ProfileHeaderViewModel(
                profilePictureUrl: profilePictureURL,
                followingCount: following,
                followerCount: followers,
                recipeCount: recipes,
                bio: bio,
                buttonType: buttonType,
                name: name,
                location: location
            )
            self.collectionView?.reloadData()
        }
    }

    
    
 
    @objc func didTapSettings(){
        let vc = SettingsViewController()
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    
    private func configure() {
        if isCurrentUser{
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "gear"),
                style: .done,
                target: self,
                action: #selector(didTapSettings)
            )
        }
        
    }
    

}
    
extension UIView {
    //reusable function to add constraints
    func anchor(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, paddingTop: CGFloat? = 0, paddingLeft: CGFloat? = 0, paddingBottom: CGFloat? = 0, paddingRight: CGFloat? = 0, width: CGFloat? = nil, height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top{
            topAnchor.constraint(equalTo: top, constant:paddingTop!).isActive = true
        }
        
        if let left = left{
            leftAnchor.constraint(equalTo: left, constant:paddingLeft!).isActive = true
        }
        
        if let right = right{
            if let paddingRight = paddingRight {
                self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
            }
        }
        if let bottom = bottom{
            if let paddingBottom = paddingBottom {
                self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
            }
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height{
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let post = posts[indexPath.row]
        let vc = PostViewController(post: post)
        navigationController?.pushViewController(vc, animated: true)
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            fatalError()
        }
        //TEMP CHANGE LOOK AT ME LATER ON
        let post = posts[indexPath.row]
        let postUrls = post.postURLs
        for url in postUrls {
            cell.configure(with: URL(string: url))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
            let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier,
            for: indexPath
        ) as? ProfileHeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        if let viewModel = headerViewModel{
            headerView.configure(with: viewModel)
            headerView.countContainerView.delegate = self
        }
        return headerView
    }
    
    
}
extension ProfileViewController: ProfileHeaderViewDelegate{
    func ProfileHeaderViewDelegateDidTapFollowers(_ containerView: ProfileHeaderView) {
        
    }
    
    func ProfileHeaderViewDelegateDidTapFollowing(_ containerView: ProfileHeaderView) {
            
    }
    
    func ProfileHeaderViewDelegateDidTapRecipe(_ containerView: ProfileHeaderView) {
        
    }
    
    func ProfileHeaderViewDelegateDidTapEditProfile(_ containerView: ProfileHeaderView) {
        let vc = EditProfileViewController()
        vc.completion = { [weak self] in
            self?.headerViewModel = nil
            self?.fetchUserInfo()
        }
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    func ProfileHeaderViewDelegateDidTapFollow(_ containerView: ProfileHeaderView) {
        
    }
    
    func ProfileHeaderViewDelegateDidTapUnFollow(_ containerView: ProfileHeaderView) {
        
    }
    
    
    
}
extension ProfileViewController{
    //  COLLECTION VIEW FUNC
    func configureCollectionView(){
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { index, _ -> NSCollectionLayoutSection in
                
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                item.contentInsets = NSDirectionalEdgeInsets(
                    top: 1,
                    leading: 1,
                    bottom: 1,
                    trailing: 1
                )
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalWidth(0.33)
                    ),
                    subitem: item,
                    count: 3
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [
                    NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .fractionalWidth(0.65)
                        ),
                        elementKind: UICollectionView.elementKindSectionHeader,
                        alignment: .top)
                ]
                return section
            })
        )
        collectionView.register(PhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.register(
            ProfileHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier
        )
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        self.collectionView = collectionView
    }
}




