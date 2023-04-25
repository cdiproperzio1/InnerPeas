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
    var rating: Int?
    var myRating: UILabel?
    var postImage:UIImageView?
    var postTitle: UILabel?
    var postDirections: UILabel?
    var postIngredients: UILabel?
    var scrollView = UIScrollView()
    let contentView = UIView()
    var profileImageView = UIImageView()
    var arrStars=[UIImageView]()

    
    let post: Post
    var currentIndex=0
    init(post: Post){
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder){
        fatalError()
    }
    let ref = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(post.title)"
        
        scrollView = UIScrollView(frame: view.frame)
        view.addSubview(scrollView)
        
        profileImageView = UIImageView(frame: CGRect(x: 50, y: 150, width: 50, height: 50))
        profileImageView.layer.cornerRadius = 50 / 2
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.masksToBounds = true
        profileImageView.clipsToBounds = true
        scrollView.addSubview(profileImageView)
        myRating=UILabel(frame: CGRect(x: (self.view.width/2)-50, y: 50, width: 100, height: 50))
        myRating!.text="Not Rated"
        myRating!.textAlignment = .center
        myRating?.textColor = .systemGray
        view.backgroundColor = .systemBackground
        scrollView.addSubview(myRating!)
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
        preLoadRating();
        postTitle!.text="\(username[0])"
        postTitle!.font = UIFont.boldSystemFont(ofSize: 16.0)
        postDirections=UILabel(frame: CGRect(x: 50, y: 200+(self.view.frame.width-100), width: self.view.frame.width-100, height: 50))
        postDirections!.text=("\nDirections\n---------------\n\(post.directions)")
        postDirections!.textColor = .systemGray
        postDirections!.lineBreakMode = .byWordWrapping
        postDirections!.numberOfLines = 0

        postDirections?.sizeToFit()
        scrollView.addSubview(postDirections!)
        
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
        scrollView.addSubview(postIngredients!)
        scrollView.contentSize = CGSize(width: view.frame.width, height: self.view.frame.origin.y + self.view.frame.height+postDirections!.height+postIngredients!.height)
        
        postImage!.backgroundColor = .white
        postImage!.layer.borderColor = UIColor.white.cgColor
        scrollView.addSubview(postTitle!)
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
        ratingSystem()
        scrollView.addSubview(postImage!)
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
    func ratingSystem(){
        for i in 1...5{
            if i == 1{
                let star = UIImageView(frame: CGRect(x: (Int(self.view.frame.width)/2)-50-10, y: 100, width: 20, height: 20))
                star.image=UIImage(systemName: "star.fill")
                let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
                star.addGestureRecognizer(tapGR)
                star.isUserInteractionEnabled = true
                star.tintColor = .systemGray
                star.tag=i
                arrStars.append(star)
                scrollView.addSubview(star)
            }
            else if i == 2 {
                let star = UIImageView(frame: CGRect(x: (Int(self.view.frame.width)/2)-25-10, y: 100, width: 20, height: 20))
                star.image=UIImage(systemName: "star.fill")
                star.tag=i
                star.tintColor = .systemGray
                let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
                star.addGestureRecognizer(tapGR)
                star.isUserInteractionEnabled = true
                arrStars.append(star)
                scrollView.addSubview(star)
            }
            else if i==3{
                let star = UIImageView(frame: CGRect(x: (self.view.frame.width/2-10), y: 100, width: 20, height: 20))
                star.image=UIImage(systemName: "star.fill")
                star.tintColor = .systemGray
                star.tag=i
                let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
                star.addGestureRecognizer(tapGR)
                star.isUserInteractionEnabled = true
                arrStars.append(star)
                scrollView.addSubview(star)
            }
            else{
                let star = UIImageView(frame: CGRect(x: Int(self.view.frame.width/2)+(25*(i-3)-10), y: 100, width: 20, height: 20))
                star.tintColor = .systemGray
                star.image=UIImage(systemName: "star.fill")
                star.tag=i
                let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
                star.addGestureRecognizer(tapGR)
                star.isUserInteractionEnabled = true
                arrStars.append(star)
                scrollView.addSubview(star)
            }
            
        }
    }
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        let index=sender.view?.tag
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        for i in 0..<index!{
            arrStars[i].tintColor=(.yellow)
        }
        for i in index!..<5{
            arrStars[i].tintColor=(.systemGray)
        }
       self.ref.child("Ratings").child(username).child(post.id).setValue(["Rating": index])
    }
    func preLoadRating(){
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        ref.child("Ratings").child(username).child(post.id).child("Rating").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userRating = snapshot.value as? Int else { return};
            if userRating>0{
                self.myRating?.text="My Rating"
            }
            for i in 0..<userRating{
                self.arrStars[i].tintColor=(.yellow)
            }
                for i in userRating..<5{
                    self.arrStars[i].tintColor=(.systemGray)
            }
            })
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
