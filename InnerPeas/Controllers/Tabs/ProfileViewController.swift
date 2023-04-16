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
    
    
    
    //var collectionView:UICollectionView?
    //private var viewModels = [[HomeFeedCellType]()]
    
    let User = Auth.auth().currentUser
    
//=======
    //Code from Justin
//>>>>>>> 3e28434937c021fa663385eea4a6582741122445
    private let user: User
    var firstView:Int=300
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
//<<<<<<< HEAD
//=======

    //Code from cat
    private var collectionView: UICollectionView? = nil
    private var viewModels = [[HomeFeedCellType]()]
    let userInfo=UILabel(frame: CGRect(x: 50, y: 150, width: 125, height: 200))
        
//>>>>>>> 3e28434937c021fa663385eea4a6582741122445
    //declare lazy when adding things to something. Doesn't render until called.
    lazy var containerView: UIView = {
        let view = UIView()
        var firstView=view.height
        view.backgroundColor = .systemMint
        userInfo.font = UIFont.systemFont(ofSize: 14.0)
        userInfo.textColor = .black
        view.addSubview(userInfo)
        
        //add profile image, and buttons to the container view(the box at the top of the page)
        view.addSubview(profileImageView)
        
        
        profileImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        profileImageView.anchor(left: view.leftAnchor, paddingLeft: 32, width: 120, height: 120)
        profileImageView.layer.cornerRadius = 120 / 2
//<<<<<<< HEAD
        //add buttons
        view.addSubview(friendsButton)
        friendsButton.anchor(right: view.rightAnchor, paddingRight: 32, width: 120, height: 90)
        view.addSubview(followersButton)
        followersButton.anchor(right: view.rightAnchor, paddingRight: 28, width: 120, height: 90)
        
        view.addSubview(recipesLabel)
        recipesLabel.anchor(right: view.rightAnchor, paddingRight: 32, width: 120, height: 120)
//=======
        profileImageView.layer.borderWidth = 1.0
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.masksToBounds = true
        
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.clipsToBounds = true
        
        
        
        view.addSubview(friendsButton)
        
        friendsButton.anchor(right: view.rightAnchor, paddingRight: 170, width: 70, height: 200)
        view.addSubview(followersButton)
        followersButton.anchor(right: view.rightAnchor, paddingRight: 100, width: 70, height: 200)
        
        view.addSubview(recipesLabel)
        recipesLabel.anchor(right: view.rightAnchor, paddingRight: 30, width: 70, height: 200)
//>>>>>>> 3e28434937c021fa663385eea4a6582741122445
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemPink
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let friendsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Friends", for: .normal)
        button.setTitleColor(.blue, for: .normal)
//<<<<<<< HEAD
//=======
        button.titleLabel!.font = UIFont.systemFont(ofSize: 14.0)
//>>>>>>> 3e28434937c021fa663385eea4a6582741122445
        return button
    }()
    
    let followersButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Followers", for: .normal)
        button.setTitleColor(.blue, for: .normal)
//<<<<<<< HEAD
//=======
        button.titleLabel!.font = UIFont.systemFont(ofSize: 14.0)
//>>>>>>> 3e28434937c021fa663385eea4a6582741122445
        return button
    }()
    
    let recipesLabel: UILabel = {
        let label = UILabel()
//<<<<<<< HEAD
//=======
        label.font = UIFont.systemFont(ofSize: 14.0)
//>>>>>>> 3e28434937c021fa663385eea4a6582741122445
        label.text = "Recipes"
        label.textColor = .blue
        return label
    }()


    override func viewDidLoad() {
        userInfo.lineBreakMode = .byWordWrapping
        userInfo.numberOfLines = 0
        view.backgroundColor = .white
        let email = (Auth.auth().currentUser?.email)?.lowercased()
        let UID = String((Auth.auth().currentUser?.uid)!)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 60, height: 60)
        print(firstView)
        let frame = CGRect(x:10, y: firstView + 10, width: Int(self.view.frame.width)-20, height: Int(self.view.frame.height)-firstView)
        self.collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
    
        collectionView!.backgroundColor = .lightGray
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.alwaysBounceVertical = true
        collectionView?.bounces = true
        view.addSubview(collectionView!)
        
        Database.database().reference().child("Users").queryOrdered(byChild: "email").queryEqual(toValue: email!).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else {return}
            
            if let adonis = dictionary["Adonis"] as? [String: Any] {
                if let fname = adonis["fname"] as? String { print("fname: \(fname)")
                    if let lname = adonis["lname"] as? String { print("lname: \(lname)")
                        if let bio = adonis["bio"] as? String { print("Bio: \(bio)")
                            if let location = adonis["location"] as? String { print("Location: \(location)")
                                self.userInfo.text="\(fname) \(lname) \n\(bio) \nLocation: \(location)" }
                        }
                    }}}
        }) { (Error) in
            print("Failed to fetch: ", Error)
        }
        let uid = String((Auth.auth().currentUser?.uid)!)
        
        let pathReference = Storage.storage().reference(withPath: "image/\(uid).png")
        pathReference.getData(maxSize: 1 * 2048 * 2048) { data, error in
            if let error = error {
                print(error)
                // Uh-oh, an error occurred!
            } else {
                // Data for "images/island.jpg" is returned
                let myImage = UIImage(data: data!)
                self.postImages.append(myImage!)
                //collectionView?.reloadData()
                self.profileImageView.image=myImage
                
            }
        }
        
        view.addSubview(profileImageView)
        view.addSubview(containerView)
        containerView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 300)
        
        //        commentsRef.observe(.childAdded, with: { (snapshot) -> Void in
        //          self.comments.append(snapshot)
        //          print(snapshot)
        //          print(comments)
        //          self.tableView.insertRows(
        //            at: [IndexPath(row: self.comments.count - 1, section: self.kSectionComments)],
        //            with: UITableView.RowAnimation.automatic
        //          )
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath)
        myCell.backgroundColor = .blue
        return myCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           print("User tapped on item \(indexPath.row)")
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
    
//=======


        

   /* override func viewDidLoad() {
        super.viewDidLoad()
        title = user.username.uppercased()
        view.backgroundColor = .systemBackground
        view.addSubview(profileImageView)
        view.addSubview(containerView)
        //layout for post?
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()

        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 60, height: 60)
        print(firstView)
        let frame = CGRect(x:10, y: firstView + 10, width: Int(self.view.frame.width)-20, height: Int(self.view.frame.height)-firstView)
        self.collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
    
        collectionView!.backgroundColor = .lightGray
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        //collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.alwaysBounceVertical = true
        collectionView?.bounces = true
        view.addSubview(collectionView!)
        
        //other stuff
        containerView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 300)
        configure()
    }*/
    
//>>>>>>> 3e28434937c021fa663385eea4a6582741122445
    @objc func didTapSettings(){
//        let vc = SettingsViewController()
//        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
//<<<<<<< HEAD
   
    
   
    
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
        //viewModels.append(postData)
        collectionView?.reloadData()
    }
    
    
//=======
    
    /*private func configure() {
        if isCurrentUser{
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "gear"),
                style: .done,
                target: self,
                action: #selector(didTapSettings)
            )
        }
    
    }*/
//>>>>>>> 3e28434937c021fa663385eea4a6582741122445
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

//<<<<<<< HEAD
//=======




//>>>>>>> 3e28434937c021fa663385eea4a6582741122445
