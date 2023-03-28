//
//  LookForFriendsViewController.swift
//  InnerPeas
//
//  Created by Anaya Potter on 3/28/23.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class LookForFriendsViewController: UIViewController {

        let searchController = UISearchController()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Looking for friends"
        navigationItem.searchController = searchController
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
