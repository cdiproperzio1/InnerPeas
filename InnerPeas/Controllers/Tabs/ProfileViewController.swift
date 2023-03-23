import UIKit
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController, UICollectionViewDelegate  {
    
    private var collectionView: UICollectionView? = nil
    private var viewModels = [[HomeFeedCellType]()]
    
    let User = Auth.auth().currentUser
    
    private let user: User
    
    private var isCurrentUser: Bool{
        return (user.email != nil)
    }
    
    init(user: User){
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //declare lazy when adding things to something. Doesn't render until called.
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        
        view.addSubview(profileImageView)
        profileImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        profileImageView.anchor(left: view.leftAnchor, paddingLeft: 32, width: 120, height: 120)
        profileImageView.layer.cornerRadius = 120 / 2
        
        view.addSubview(friendsButton)
        friendsButton.anchor(right: view.rightAnchor, paddingRight: 32, width: 120, height: 90)
        
        view.addSubview(followersButton)
        followersButton.anchor(right: view.rightAnchor, paddingRight: 28, width: 120, height: 90)
        
        view.addSubview(recipesLabel)
        recipesLabel.anchor(right: view.rightAnchor, paddingRight: 32, width: 120, height: 120)
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemPink
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let friendsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Friends", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    let followersButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Followers", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    let recipesLabel: UILabel = {
        let label = UILabel()
        label.text = "Recipes"
        label.textColor = .blue
        return label
    }()
        
  //  var ref: DatabaseReference!
//    ref = Database.database().reference()
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = user.email
//        view.backgroundColor = .systemBackground
//
//        commentsRef.observe(.childAdded, with: { (snapshot) -> Void in
//          self.comments.append(snapshot)
//          print(snapshot)
//          print(comments)
//          self.tableView.insertRows(
//            at: [IndexPath(row: self.comments.count - 1, section: self.kSectionComments)],
//            with: UITableView.RowAnimation.automatic
//          )
//            configure()
        //configureCollectionView()
        fetchPost()
        view.addSubview(profileImageView)
        view.addSubview(containerView)
        containerView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 300)
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
    @objc func didTapSettings(){
        let vc = SettingsViewController()
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
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
        //collectionView.dataSource = self
        
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
    })
//    }
    
   
    
   
    
    private func fetchPost(){
        //test data
        let postData: [HomeFeedCellType] =
        [
            .poster(
                viewModel: PosterCollectionViewCell(
                    username: "FoodThatSmacks",
                    profilePictureURL: URL(string: "https://mymodernmet.com/wp/wp-content/uploads/2020/01/baby-yoda-eating-food-13.jpg")!
                    
                )
            ),
            .post(
                viewModel: PostCollectionViewCell(
                    postUrl: URL(string: "https://www.foodandwine.com/thmb/Yt46CaGExGFVjruxJsNSFjNVMo0=/2000x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/Super-Scoops-FT-2-MAG0622-00568f6534a44e0c8a422b66b25d6cf6.jpg")!
                )
            ),
            
                .postDescription(
                    viewModel: PostDescriptionCollectionViewCell(
                        name: "Ice Cream with a long title to see how it holds in the frame",
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
        viewModels.append(postData)
        collectionView?.reloadData()
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

