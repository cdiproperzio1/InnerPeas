//
//  CommentViewController.swift
//  InnerPeas
//
//  Created by Cat DiProperzio on 4/30/23.
//

import UIKit
import FirebaseDatabase

class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let ref = Database.database().reference()
    let post: Post
    var tableView = UITableView()
    var comments=[String]()
    var textField=UITextField()
    var addButton = UIButton()
    
    
    init(post: Post){
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder){
        fatalError()
    }
    override func viewDidLoad() {
        
        title = "Comments for \(post.title)"
        view.backgroundColor = .systemBackground
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height-150))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate=self
        tableView.dataSource=self
        textField=UITextField(frame: (CGRect(x: 20, y: self.view.frame.height-150, width: self.view.frame.width-70, height: 50)))
        textField.tintColor = .systemGray
        textField.placeholder="Add Comment"
        tableView.tintColor = .systemGreen
        addButton=UIButton(frame: (CGRect(x: self.view.frame.width-60, y: self.view.frame.height-150, width: 40, height: 40)))
        addButton.tintColor = .systemGreen
        addButton.backgroundColor = UIColor.tintColor
        addButton.layer.cornerRadius = 15
        addButton.setTitle("Post", for: .normal)
        addButton.addTarget(
            self,
            action: #selector(postComment),
            for: .touchUpInside)
        self.view.addSubview(addButton)
        self.view.addSubview(textField)
        self.view.addSubview(tableView)
        loadData()
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped a comment")
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.tintColor = .systemGray
        cell.textLabel?.text = comments[indexPath.row]
        return cell;
    }
    @objc func postComment(){
        guard let text = self.textField.text else {return}
        
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        let fullText = "\(username): \(text)"
        comments.append(fullText)
        self.textField.text=""
        ref.child("Comments").child(self.post.id).setValue(["Comment": text, "User": username])
        tableView.reloadData()
    }
    func loadData(){
        ref.child("Comments").child(post.id).observeSingleEvent(of: .value, with: { [self] (snapshot) in
            let comment = snapshot.childSnapshot(forPath: "Comment").value as? String ?? " "
            let user = snapshot.childSnapshot(forPath: "User").value as? String ?? " "
            let text = "\(user): \(comment)"
            print(text)
            self.comments.append(text)
            self.tableView.reloadData()
        })
    }
}
