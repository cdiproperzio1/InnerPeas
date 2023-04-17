//
//  AddPostViewController.swift
//  InnerPeas
//
//  Created by Cat DiProperzio on 2/28/23.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class AddPostViewController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, ImagePickerDelegate{
    
    
    var images = [UIImage]()
    var dirList=UITextView()
    var imagePicker: ImagePicker!
    
    var tableView = UITableView()
    
    let postName=UITextField(frame: CGRect(x: 50, y: 100, width: 325, height: 40))
    let amountTextField=UITextField(frame: CGRect(x: 225, y: 450, width: 100, height: 40))
    let ingredTextField=UITextField(frame: CGRect(x: 50, y: 450, width: 125, height: 40))
    var ingredients = [[String:String]]()
    
    
    
    let image1frame = UIImageView(frame: CGRect(x: 50, y: 400, width: 40, height: 40))
    let image2frame = UIImageView(frame: CGRect(x: 100, y: 400, width: 40, height: 40))
    let image3frame = UIImageView(frame: CGRect(x: 150, y: 400, width: 40, height: 40))
    
    
    lazy var okButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Post!", for: .normal)
        button.addTarget(
            self,
            action: #selector(postPost),
            for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        view.backgroundColor = .systemBackground
        dirList=UITextView(frame: CGRect(x: 50, y: 150, width: self.view.frame.width - 100, height: 200))
        
        okButton.frame = CGRect(
            x: view.width/2,
            y: 720,
            width: 100,
            height: 40)
        self.view.addSubview(okButton)
        
        //DIRECTIONS FIELD
        dirList.textAlignment = NSTextAlignment.left
        dirList.textColor = .systemGray
        dirList.text = "Directions"
        dirList.backgroundColor = .secondarySystemBackground
        dirList.font = .systemFont(ofSize: 22)
        self.view.addSubview(dirList)
        dirList.delegate=self
        
        //IMAGE FRAMES
        self.view.addSubview(image1frame)
        self.view.addSubview(image2frame)
        self.view.addSubview(image3frame)

        
        //INGREDIENTS FIELD
        ingredTextField.placeholder = "Ingredient"
        self.view.addSubview(ingredTextField)
        
        //POST NAME FIELD
        postName.placeholder = "Name"
        postName.font = .systemFont(ofSize: 22)
        postName.backgroundColor = .secondarySystemBackground
        self.view.addSubview(postName)
        
        //AMOUNTS FIELD
        amountTextField.placeholder = "Amount"
        self.view.addSubview(amountTextField)
        
        let addPhoto = UIButton(frame: CGRect(x: 225, y: 400, width: 140, height: 40))
        addPhoto.backgroundColor = .systemBlue
        addPhoto.setTitle("Upload Photo", for: .normal)
        addPhoto.addTarget(self, action: #selector(selectPhoto), for: .touchUpInside)
        self.view.addSubview(addPhoto)
        
        
        tableView = UITableView(frame: CGRect(x: 50, y: 500, width: self.view.width-100, height: 200))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate=self
        tableView.dataSource=self
        
        self.view.addSubview(tableView)
        let addIngred = UIButton(frame: CGRect(x: 325, y: 450, width: 40, height: 40))
        addIngred.backgroundColor = .systemBlue
        addIngred.setTitle("Add", for: .normal)
        addIngred.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(addIngred)
        //        ingredList.numberOfLines=2
        //        ingredList.text=""
        ingredTextField.text=""
        amountTextField.text=""
        postName.text=""
        //        ingredList.textAlignment=NSTextAlignment.left
        //        ingredList.textColor = .black
        //self.view.addSubview(ingredList)
        
    }
    
    
    
    @objc func buttonAction(sender: UIButton!) {
        ingredients.append([ ingredTextField.text! : amountTextField.text! ])
        print(ingredients)
        ingredTextField.text=""
        amountTextField.text=""
        tableView.reloadData()
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    func textViewDidEndEditing(_ dirList : UITextView) {
        if dirList.text.isEmpty {
            dirList.text = "Directions"
            dirList.textColor = .secondarySystemBackground
        }
        
    }
    func textViewDidBeginEditing(_ dirList : UITextView ) {
        if dirList.text == "Directions" {
            dirList.text = ""
            dirList.textColor = .systemCyan
        }
    }
    @objc func selectPhoto(_ sender: UIButton){
        if(images.count<3){
            self.imagePicker = ImagePicker(presentationController: self, delegate: self)
            self.imagePicker.present(from: sender)
        }
        else{
            print("error")
            //error handling
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped me")
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle:   UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            ingredients.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .middle)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
    //CREATE POST ID FUNC
    private func createPostID() -> String? {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDateTimeString = dateFormatter.string(from: Date())
        let randomNumber = Int.random(in: 0...1000)
        
        let postID = "\(username)_\(randomNumber)_\(currentDateTimeString)"
        
        return postID
    }


    //ADD POST TO DB

    @objc func postPost() {
        guard let newPostID = createPostID() else {
            return
        }

        //var imageIDs = [String]()
        var imageUrls: [String] = []

        let group = DispatchGroup()

        for i in 0..<images.count {
            group.enter()
            let tempImage = images[i]
            guard let data = tempImage.pngData() else {
                group.leave()
                return
            }
            let imageID = UUID().uuidString
            UserDefaults.standard.setValue(imageID, forKey: "image_ID")

            StorageManager.shared.uploadPost(
                data: data,
                id: newPostID,
                imageID: imageID
            ) { newPostDownloadURL in
                defer { group.leave() }
                guard let url = newPostDownloadURL else {
                    print("Error: Failed to upload")
                    return
                }
                imageUrls.append(url.absoluteString)
            }
        }

        group.notify(queue: .main) { [self] in
            let newPost = Post(
                id: newPostID,
                title: postName.text ?? "Recipe Name",
                directions: dirList.text ?? "Recipe Directions",
                postURLString: "", 
                postURLs: imageUrls,
                ingredients: ingredients
            )
            DatabaseManager.shared.createPost(newPost: newPost) { [weak self] finished in
                guard finished else {
                    return
                }
                DispatchQueue.main.async {
                    self?.navigationController?.popToRootViewController(animated: false)
                    self?.tabBarController?.selectedIndex = 0
                }
            }
            
            self.images=[UIImage]()
            image1frame.image=nil
            image2frame.image=nil
            image3frame.image=nil
            dirList.text=""
            ingredients=[[String:String]]()
            tableView.reloadData()
    }



    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let val=ingredients[indexPath.row]
        var prettyJ=(String(val.description)).replacingOccurrences(of: "\"", with: "")
        prettyJ=prettyJ.replacingOccurrences(of: "[", with: "")
        prettyJ=prettyJ.replacingOccurrences(of: "]", with: "")
        cell.textLabel?.text = (prettyJ)
        return cell;
    }
    
    
    func didSelect(image: UIImage?) {
        guard let image = image else {
            return
        }
        if(images.count==0){
            images.append(image)
            self.image1frame.image=image
        }
        else if(images.count==1){
            images.append(image)
            self.image2frame.image=image
        }
        else if(images.count==2){
            images.append(image)
            self.image3frame.image=image
        }
        else{
            return;
        }
    }
}

//workig code
//@objc func postPost(){
//        guard let username = UserDefaults.standard.string(forKey: "username"),
//              let email = UserDefaults.standard.string(forKey: "email") else{
//            return
//        }
//        let currentUser = User(
//            username: username,
//            email: email
//        )
//
//        guard let newPostID = createPostID() else {
//            return
//        }
//
//        let newPost = Post(
//            id: newPostID,
//            title: postName.text ?? "Recipe Name",
//            directions: dirList.text ?? "Recipe Directions",
//            postURLString: url.absoluteString
//            ingredients: ingredients
//        )
//
//        //CATS CODE
//        var imageIDs=[String]()
//
//        //store items in DB
//        //for each image that was added go through them get the image data and set it as a UI image give each image a unique ID
//        for i in 0..<images.count{
//            let tempImage = images[i];
//            guard let data = tempImage.pngData() else {
//                return
//            }
//            let imageID = UUID().uuidString
//
//            StorageManager.shared.uploadPost(
//                data: data,
//                id: newPostID,
//                imageID: imageID
//            ) { newPostDownloadURL in
//                guard let url = newPostDownloadURL else{
//                    print("Error: Failed to upload")
//                    return
//                }
//            }
//
//        }
//
//        DatabaseManager.shared.createPost(newPost: newPost) { [weak self] finished in
//            guard finished else{
//                return
//            }
//            DispatchQueue.main.async {
//                self?.navigationController?.popToRootViewController(animated: false)
//                self?.tabBarController?.selectedIndex = 0
//            }
//        }
