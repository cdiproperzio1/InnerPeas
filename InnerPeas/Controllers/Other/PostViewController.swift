//
//  PostViewController.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 2/19/23.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class PostViewController: UIViewController {
    var postImage:UIImageView?
    var postTitle: UILabel?
    var postDirections: UILabel?
    var postIngredients: UILabel?
    let scrollView = UIScrollView()
    let contentView = UIView()
    var profileImageView = UIImageView()

    
    let post: Post
    var currentIndex=0
    init(post: Post){
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder){
        fatalError()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        title = "\(post.title)"
        
        
        profileImageView = UIImageView(frame: CGRect(x: 50, y: 150, width: 50, height: 50))
        profileImageView.layer.cornerRadius = 50 / 2
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.masksToBounds = true
        profileImageView.clipsToBounds = true
        view.addSubview(profileImageView)
        
        view.backgroundColor = .systemBackground
        postTitle=UILabel(frame: CGRect(x: 70+(profileImageView.width), y: 150, width: (self.view.frame.width-100), height: 50))
        postImage = UIImageView(frame: CGRect(x: 50, y: 200, width: self.view.frame.width-100, height: self.view.frame.width-100))
        postTitle?.textColor = .systemGray;
        //get username by substring in id
        let id = post.id
        let delimiter="_"
        let username = id.components(separatedBy: delimiter)

        let pathReference = Storage.storage().reference(withPath: "\(username[0])/profile_picture.png")
        pathReference.getData(maxSize: 1 * 4048 * 4048) { data, error in
            if let error = error {
                print(error)
                // Uh-oh, an error occurred!
            } else {
                // Data for "images/island.jpg" is returned
                let myImage = UIImage(data: data!)
                self.profileImageView.image=myImage
                
            }
        }
        
        postTitle!.text="\(username[0])"
        postTitle!.font = UIFont.boldSystemFont(ofSize: 16.0)
        postDirections=UILabel(frame: CGRect(x: 50, y: 200+(self.view.frame.width-100), width: self.view.frame.width-100, height: 50))
        postDirections!.text=("\nDirections\n---------------\n\(post.directions)")
        postDirections!.textColor = .systemGray
        postDirections!.lineBreakMode = .byWordWrapping
        postDirections!.numberOfLines = 0

        postDirections?.sizeToFit()
        view.addSubview(postDirections!)
        
        let y = (200+(self.view.frame.width-100)+postDirections!.height)
        postIngredients=UILabel(frame: CGRect(x: 50, y: y, width: self.view.frame.width-100, height: 50))
    
        postIngredients!.textColor = .systemGray
        postIngredients!.lineBreakMode = .byWordWrapping
        postIngredients!.numberOfLines = 0
        postIngredients!.text="\nIngredients\n---------------"
        for i in 0..<post.ingredients.count{
            for (key, value) in post.ingredients[i] {
                self.postIngredients!.text!+=("\n\(value) \(key)")
            }
        }
        

        postIngredients?.sizeToFit()
        view.addSubview(postIngredients!)
        
        
        postImage!.backgroundColor = .white
        postImage!.layer.borderColor = UIColor.white.cgColor
        view.addSubview(postTitle!)
        let url=post.postURLs[0]
        let ref = Storage.storage().reference(forURL: url)
        ref.getData(maxSize: (1 * 4028 * 4028)) { (data, error) in
            if let err = error {
                print(err)
            } else {
                if let image  = data {
                    let myImage: UIImage! = UIImage(data: image)
                    self.postImage!.image=myImage
                }
            }
        }
        view.addSubview(postImage!)
        postImage!.isUserInteractionEnabled = true
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.getSwipeAction(_:)))
        self.postImage!.addGestureRecognizer(swipeGesture)
    }
    @objc func getSwipeAction( _ recognizer : UISwipeGestureRecognizer){
        
        if recognizer.direction == .right{
            currentIndex=currentIndex-1;
            if(currentIndex<0){
                currentIndex=(post.postURLs.count-1);
            }
            
                let url=post.postURLs[currentIndex]
                let ref = Storage.storage().reference(forURL: url)
                ref.getData(maxSize: (1 * 4048 * 4048)) { (data, error) in
                    if let err = error {
                        print(err)
                    } else {
                        if let image  = data {
                            let myImage: UIImage! = UIImage(data: image)
                            self.postImage!.image=myImage
                        }
                    }
                }
            
        } else if recognizer.direction == .left {
            currentIndex=currentIndex+1
            if(currentIndex>=post.postURLs.count){
                currentIndex=0;
            }
            
            
                let url=post.postURLs[currentIndex]
                let ref = Storage.storage().reference(forURL: url)
                ref.getData(maxSize: (1 * 4048 * 4048)) { (data, error) in
                    if let err = error {
                        print(err)
                    } else {
                        if let image  = data {
                            let myImage: UIImage! = UIImage(data: image)
                            self.postImage!.image=myImage
                        }
                    }
                }
        }
    }
    func setupScrollView(){
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            contentView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(scrollView)
            scrollView.addSubview(contentView)
            
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        }


    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
