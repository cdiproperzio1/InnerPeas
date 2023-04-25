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


class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {
    
    private var collectionView:UICollectionView?
    private var viewModels = [[HomeFeedCellType]()]
    let User = Auth.auth().currentUser
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
    
    //Code from cat
    
    //declare lazy when adding things to something. Doesn't render until called.
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        userInfo.font = UIFont.systemFont(ofSize: 16)
        //userInfo.textColor = .secondaryLabel
        view.addSubview(userInfo)
        
        self.recipesCount=UILabel(frame: CGRect(x: self.view.frame.width-100, y: 100, width: 40, height: 40))
        self.recipesCount!.font = UIFont.systemFont(ofSize: 14.0)
        //self.recipesCount!.textColor = .blue
        view.addSubview(self.recipesCount!)
        
        configure()
        
        let buttonWidth: CGFloat = (view.width-10)/3
        view.addSubview(friendsButton)
        friendsButton.anchor(right: view.rightAnchor, paddingRight: 170, width: 70, height: 200)
        //friendsButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: view.height/2)
        
        //view.addSubview(followButton)
        //followButton.anchor(top: view.topAnchor, right: view.rightAnchor, paddingTop: 5, width: 150, height: 100)

        view.addSubview(followersButton)
        followersButton.anchor(right: view.rightAnchor, paddingRight: 100, width: 70, height: 200)
        
        view.addSubview(recipesLabel)
        recipesLabel.anchor(right: view.rightAnchor, paddingRight: 30, width: 70, height: 200)
        
        
        view.addSubview(profileImageView)
        profileImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        profileImageView.anchor(left: view.leftAnchor, paddingLeft: 32, width: 120, height: 120)
        profileImageView.layer.cornerRadius = 120 / 2
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.masksToBounds = true
        
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.clipsToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let friendsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Friends", for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 0.5
        //button.layer.borderColor = UIColor.tertiaryLabel.cgColor
        button.titleLabel!.font = UIFont.systemFont(ofSize: 14.0)
        return button
    }()
    
    let followersButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Followers", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 0.5
        //ffrttgv button.layer.borderColor = UIColor.tertiaryLabel.cgColor
        button.titleLabel!.font = UIFont.systemFont(ofSize: 14.0)
        return button
    }()
    
    let recipesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.text = "Recipes"
        label.tintColor = .label
        return label
    }()
    
    //follow button
    let followButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Follow", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = user.username.uppercased()
        view.backgroundColor = .systemBackground
        view.addSubview(containerView)
        userInfo.lineBreakMode = .byWordWrapping
        userInfo.numberOfLines = 0
        view.backgroundColor = .systemBackground
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        layout.itemSize = CGSize(width: 110, height: 110)
        print(firstView)
        
        
        let frame = CGRect(x:10, y: firstView + 10, width: Int(self.view.frame.width)-20, height: Int(self.view.frame.height)-firstView)
        self.collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        
        collectionView!.backgroundColor = .systemBackground
        collectionView?.register(PhotoCollectionViewCell.self,
                                 forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.alwaysBounceVertical = true
        collectionView?.bounces = true
        view.addSubview(collectionView!)
        
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        Database.database().reference().child("Users/\(username)").getData(completion:  { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            guard let dictionary = snapshot!.value as? [String: Any] else {return}
            
            guard let bio = dictionary["bio"] else { return}
            guard let fname = dictionary["firstName"] else {return}
            guard let lname = dictionary["lastName"] else {return}
            guard let location = dictionary["location"] else {return}
            
            self.userInfo.text="\(fname) \(lname) \n\(bio) \nLocation: \(location)"
        });
        
        Database.database().reference().child("Users/\(username)/Posts").getData(completion:  { error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return;
            }
            guard let dictionary = snapshot!.value as? [String: Any] else {return}
            for (key, data) in dictionary {
                if let data = data as? [String: Any] {
                    var postData = data
                    postData["id"] = key
                    if let post = Post(with: postData) {
                        self.posts.append(post)
                    }
                }
            }
            self.collectionView?.reloadData()
            
        });
        
        let pathReference = Storage.storage().reference(withPath: "\(username)/profile_picture.png")
        pathReference.getData(maxSize: 1 * 2048 * 2048) { data, error in
            if let error = error {
                print(error)
                // Uh-oh, an error occurred!
            } else {
                // Data for "images/island.jpg" is returned
                let myImage = UIImage(data: data!)
                self.profileImageView.image=myImage
                
            }
        }
        view.addSubview(containerView)
        containerView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 300)
        
        
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.recipesCount!.text="\(posts.count)"
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            fatalError()
        }
        let post = posts[indexPath.row]
        let postUrls = post.postURLs
        for url in postUrls {
            cell.configure(with: URL(string: url))
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let post = posts[indexPath.row]
        let vc = PostViewController(post: post)
        navigationController?.pushViewController(vc, animated: true)
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




