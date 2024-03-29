//
//  SettingsViewController.swift
//  InnerPeas
//
//  Created by Justin Hamilton on 3/6/23.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")
        
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                           target: self,
                                                           action: #selector(didTapClose))
        
        createTableFooter()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    @objc func didTapClose(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapSignOut(){
        
        let actionSheet = UIAlertController(title: "Sign Out",
                                            message: "Are you Sure?",
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { [weak self]_ in
            print("signout presed")
            AuthManager.shared.signOut{success in
                if success{
                    DispatchQueue.main.async{
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        guard let vc = storyboard.instantiateViewController(withIdentifier: "FirstTimeViewController") as? FirstTimeViewController else {
                            fatalError("Unable to instantiate view controller.")
                        }
                        let navVC = UINavigationController(rootViewController: vc)
                        navVC.modalPresentationStyle = .fullScreen
                        self?.present(navVC, animated: true)
                    }
                }
            }
            
        }))
        present(actionSheet, animated: true)
    }
    //switch for light and dark mode - Anaya
    @objc func onClickSwitch(sender:UISwitch!)
    {
        if #available(iOS 13.0, *){
            let appDelegate = UIApplication.shared.windows.first
            
            if sender.isOn{
                appDelegate?.overrideUserInterfaceStyle = .light
                return
            }
            
            appDelegate?.overrideUserInterfaceStyle = .dark
            return
        }
        
    }
    
    private func createTableFooter(){
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: 50))
        footer.clipsToBounds = true
        
        let button = UIButton(frame: footer.bounds)
        footer.addSubview(button)
        button.setTitle("Sign Out",
                        for: .normal)
        button.setTitleColor(.systemRed,
                             for: .normal)
        button.addTarget(self, action: #selector(didTapSignOut), for: .touchUpInside)
        
        tableView.tableFooterView = footer
        
        //light or dark mode switch button- Anaya
        let switchButton = UISwitch(frame: footer.bounds)
        footer.addSubview(switchButton)
        switchButton.addTarget(self, action: #selector(self.onClickSwitch), for: .valueChanged)
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
