import UIKit
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController, UICollectionViewDelegate  {
    
    // private var collectionView: UICollectionView? = nil
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .green
        return imageView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .systemBackground
        view.addSubview(profileImageView)
        view.addSubview(containerView)
        containerView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 300)
        //configureCollectionView()
        profileImageView.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 44, paddingLeft: 32, width: 120, height: 120)
        
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
