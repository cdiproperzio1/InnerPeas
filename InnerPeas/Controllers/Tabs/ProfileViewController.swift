import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase


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
        
        //add profile image, and buttons to the container view(the box at the top of the page)
        view.addSubview(profileImageView)
        profileImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        profileImageView.anchor(left: view.leftAnchor, paddingLeft: 32, width: 120, height: 120)
        //profileImageView.layer.cornerRadius = 120 / 2
        

        profileImageView.layer.borderWidth = 1.0
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
        profileImageView.clipsToBounds = true
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
    
    
   override func viewDidLoad() {
       let email = Auth.auth().currentUser?.email
       let UID = String((Auth.auth().currentUser?.uid)!)
       print(UID)
       var userName:String=""
       Database.database().reference().child("Users").queryOrdered(byChild: "email").queryEqual(toValue: email).observeSingleEvent(of: .value, with: { (snapshot) in
               guard let dictionary = snapshot.value as? [String:Any] else {return}
           var i = 0;
               dictionary.forEach({ (key , value) in
                   if i == 0{
                       userName=key
                       i=1
                   }
                   print("Key \(key), value \(value) ")
               })
           }) { (Error) in
               print("Failed to fetch: ", Error)
           }
       print("here for pic")
       print(userName)
       let uid = String((Auth.auth().currentUser?.uid)!)
       print(uid)
       let pathReference = Storage.storage().reference(withPath: "image/\(uid).png")
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
       
       fetchPost()
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
//        let vc = SettingsViewController()
//        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
   
    
   
    
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
