//
//  PostViewController.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 2/19/23.
//

import UIKit
import FirebaseStorage

class PostViewController: UIViewController {
    var postImage:UIImageView?
    var postTitle: UILabel?
    var postDirections: UILabel?
    
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
        title = "Post"
        view.backgroundColor = .systemBackground
        postTitle=UILabel(frame: CGRect(x: 50, y: 150, width: self.view.frame.width-100, height: 50))
        postImage = UIImageView(frame: CGRect(x: 50, y: 200, width: self.view.frame.width-100, height: self.view.frame.width-100))
        postTitle?.textColor = .systemGray;
        postTitle!.text="\(post.title)"
        postDirections=UILabel(frame: CGRect(x: 50, y: 200+(self.view.frame.width-100)+50, width: self.view.frame.width-100, height: 50))
        postDirections!.text=("\(post.directions)")
        postDirections!.textColor = .systemGray
        postDirections!.lineBreakMode = .byWordWrapping
        postDirections!.numberOfLines = 0
        postDirections?.sizeToFit()
        view.addSubview(postDirections!)
        postImage!.backgroundColor = .white
        postImage!.layer.borderColor = UIColor.white.cgColor
        view.addSubview(postTitle!)
        let url=post.postURLs[0]
        let ref = Storage.storage().reference(forURL: url)
        ref.getData(maxSize: (1 * 2048 * 2048)) { (data, error) in
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

    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
