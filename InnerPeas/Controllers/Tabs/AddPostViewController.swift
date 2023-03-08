//
//  AddPostViewController.swift
//  InnerPeas
//
//  Created by Cat DiProperzio on 2/28/23.
//

import UIKit

class AddPostViewController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    var images = [UIImage]()
    var dirList=UITextView()
    
    var tableView = UITableView()
//    let ingredList=UILabel(frame: CGRect(x: 50, y: 500, width: 250, height: 250))
    let amountTextField=UITextField(frame: CGRect(x: 225, y: 450, width: 100, height: 40))
    let ingredTextField=UITextField(frame: CGRect(x: 50, y: 450, width: 125, height: 40))
    var ingredients = [[String:String]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add a Post"
        view.backgroundColor = .systemBackground
        
        dirList=UITextView(frame: CGRect(x: 50, y: 50, width: self.view.frame.width - 100, height: 250))
        
        dirList.textAlignment = NSTextAlignment.left
        dirList.text="Directions"
        dirList.font = UIFont.systemFont(ofSize: 18.0)
        dirList.textColor = UIColor.lightGray
        self.view.addSubview(dirList)
        dirList.delegate=self
        
        ingredTextField.placeholder = "Ingredient"
        self.view.addSubview(ingredTextField)
        
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
    @objc func selectPhoto(){
        print("selected a photo")
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //cell.textLabel?.text = ingredients[indexPath.row]
        return cell;
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

