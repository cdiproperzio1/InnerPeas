//
//  AddPostViewController.swift
//  InnerPeas
//
//  Created by Cat DiProperzio on 2/28/23.
//

import UIKit

class AddPostViewController: UIViewController, UITextViewDelegate {
    var images = [UIImage]()
    var dirList=UITextView(frame: CGRect(x: 50, y: 50, width: 250, height: 250))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add a Post"
        view.backgroundColor = .systemBackground
        
        dirList.text="Directions"
        dirList.textColor = UIColor.lightGray
        self.view.addSubview(dirList)
        dirList.delegate=self
        
        
        let ingredTextField=UITextField(frame: CGRect(x: 50, y: 450, width: 100, height: 40))
        ingredTextField.placeholder = "Ingredient"
        self.view.addSubview(ingredTextField)
        
        let amountTextField=UITextField(frame: CGRect(x: 200, y: 450, width: 75, height: 40))
        amountTextField.placeholder = "Amount"
        self.view.addSubview(amountTextField)
        
        
        let addIngred = UIButton(frame: CGRect(x: 275, y: 450, width: 40, height: 40))
        addIngred.backgroundColor = .systemBlue
        addIngred.setTitle("Add", for: .normal)
        addIngred.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(addIngred)
        
        
        let ingredList=UILabel(frame: CGRect(x: 50, y: 500, width: 250, height: 40))
        ingredList.textColor = .black
        self.view.addSubview(ingredList)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
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

}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

