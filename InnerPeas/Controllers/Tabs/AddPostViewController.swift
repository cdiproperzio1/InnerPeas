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
    private let storage = Storage.storage().reference()
    private let database=Database.database().reference()
    var images = [UIImage]()
    var dirList=UITextView()
    var imagePicker: ImagePicker!
    var tableView = UITableView()
    let postName=UITextField(frame: CGRect(x: 50, y: 100, width: 125, height: 40))
    let amountTextField=UITextField(frame: CGRect(x: 225, y: 450, width: 100, height: 40))
    let ingredTextField=UITextField(frame: CGRect(x: 50, y: 450, width: 125, height: 40))
    var ingredients = [[String:String]]()
    let image1 = UIImageView(frame: CGRect(x: 50, y: 400, width: 40, height: 40))
    let image2 = UIImageView(frame: CGRect(x: 100, y: 400, width: 40, height: 40))
    let image3 = UIImageView(frame: CGRect(x: 150, y: 400, width: 40, height: 40))
    var okButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        dirList=UITextView(frame: CGRect(x: 50, y: 150, width: self.view.frame.width - 100, height: 200))
        okButton=UIButton(frame: CGRect(x: (self.view.width/2)-50, y: 720, width: 100, height: 40))
        okButton.backgroundColor = .systemBlue
        okButton.setTitle("Post!", for: .normal)
        okButton.addTarget(self, action: #selector(postPost), for: .touchUpInside)
        self.view.addSubview(okButton)
        dirList.textAlignment = NSTextAlignment.left
        dirList.text="Directions"
        dirList.font = UIFont.systemFont(ofSize: 18.0)
        dirList.textColor = UIColor.lightGray
        self.view.addSubview(dirList)
        self.view.addSubview(image1)
        self.view.addSubview(image2)
        self.view.addSubview(image3)
        dirList.delegate=self
        
                
        ingredTextField.placeholder = "Ingredient"
        self.view.addSubview(ingredTextField)
        
        postName.placeholder = "Name"
        self.view.addSubview(postName)
        
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
    
    func textViewDidEndEditing(_ dirList : UITextView) {
        if self.dirList.text!.isEmpty {
            self.dirList.text = "Directions"
            self.dirList.textColor = UIColor.lightGray
        }
    }
    func textViewDidBeginEditing(_ dirList : UITextView ) {
        if self.dirList.textColor == UIColor.lightGray {
            self.dirList.text = nil
            self.dirList.textColor = UIColor.black
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
        return ingredients.count
    }
    @objc func postPost(){
        let UID = String((Auth.auth().currentUser?.uid)!)
        let postID = UUID().uuidString
        var imageIDs=[String]()
        //store items in DB
        for i in 0..<images.count{
            let tempImage = images[i];
            let imageID = UUID().uuidString
            imageIDs.append(imageID)
            guard let imageData = tempImage.pngData() else {
                return
            }
            
            storage.child("image/\(imageID).png").putData(imageData) { error in
                guard error != nil else {
                    print("failed to upload")
                    return
                }
                self.storage.child("images/file.png").downloadURL(completion: {url, error in
                    guard let url = url, error == nil else {
                        return
                    }
                    let urlString = url.absoluteString
                })
            }
        }
        
        self.database.child("Post").child(UID).child(postID).child("directions").setValue(self.dirList.text!)
        self.database.child("Post").child(UID).child(postID).child("ingredients").setValue(self.ingredients)
        self.database.child("Post").child(UID).child(postID).child("name").setValue(self.postName.text!)
        self.database.child("Post").child(UID).child(postID).child("images").setValue(imageIDs)
        
        self.images=[UIImage]()
        image1.image=nil
        image2.image=nil
        image3.image=nil
        dirList.text=""
        ingredients=[[String:String]]()
        tableView.reloadData()
        let vc = HomeViewController()
        self.navigationController?.pushViewController(vc, animated: true)
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
            self.image1.image=image
        }
        else if(images.count==1){
            images.append(image)
            self.image2.image=image
        }
        else if(images.count==2){
            images.append(image)
            self.image3.image=image
        }
        else{
            return;
        }
    }
}


  
//    @objc func postPost(){
//        guard let newPostID = createNewPostID() else{
//            return
//        }
//
//        StorageManager.shared.uploadPost(
//            //data: images.description.data(using: png),
//            id: newPostID)
//        { success in
//            guard success else{
//                print("error: failed to upload")
//                return
//            }
//        }
//
//    }
