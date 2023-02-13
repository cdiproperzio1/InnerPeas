//
//  CustomizeAccountViewController.swift
//  InnerPeas
//
//  Created by Cat DiProperzio on 2/13/23.
//

import UIKit


class CustomizeAccountViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        let image = UIImage(named: "generic")
        profileImage.layer.borderWidth = 1.0
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        textView.text = "Bio (150 Characters)"
        textView.textColor = UIColor.lightGray

        // Do any additional setup after loading the view.
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
