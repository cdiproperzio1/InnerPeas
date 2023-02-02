//
//  SignUpViewController.swift
//  LoginPage_InnerPeas
//
//  Created by Anaya Potter on 1/31/23.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var Emailtxt: UITextField!
    @IBOutlet weak var Usernametxt: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    @IBOutlet weak var ValidatePassTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func SignUpButton(_ sender: UIButton) {
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
