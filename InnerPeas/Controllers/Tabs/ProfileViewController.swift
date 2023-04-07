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


class ProfileViewController: UIViewController, UICollectionViewDelegate  {
    //Code from Justin
    private let user: User
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
    private var collectionView: UICollectionView? = nil
    private var viewModels = [[HomeFeedCellType]()]
    let userInfo=UILabel(frame: CGRect(x: 50, y: 150, width: 125, height: 200))
        
    //declare lazy when adding things to something. Doesn't render until called.
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        userInfo.font = UIFont.systemFont(ofSize: 14.0)
        userInfo.textColor = .black
        view.addSubview(userInfo)
        
        //add profile image, and buttons to the container view(the box at the top of the page)
        view.addSubview(profileImageView)
        
        
        profileImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        profileImageView.anchor(left: view.leftAnchor, paddingLeft: 32, width: 120, height: 120)
        profileImageView.layer.cornerRadius = 120 / 2
        profileImageView.layer.borderWidth = 1.0
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.clipsToBounds = true
        
        
        
        view.addSubview(friendsButton)
        
        friendsButton.anchor(right: view.rightAnchor, paddingRight: 170, width: 70, height: 200)
        view.addSubview(followersButton)
        followersButton.anchor(right: view.rightAnchor, paddingRight: 100, width: 70, height: 200)
        
        view.addSubview(recipesLabel)
        recipesLabel.anchor(right: view.rightAnchor, paddingRight: 30, width: 70, height: 200)
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
    
    let friendsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Friends", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 14.0)
        return button
    }()
    
    let followersButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Followers", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 14.0)
        return button
    }()
    
    let recipesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.text = "Recipes"
        label.textColor = .blue
        return label
    }()


        

    override func viewDidLoad() {
        super.viewDidLoad()
        title = user.username.uppercased()
        view.backgroundColor = .systemBackground
        configure()
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





