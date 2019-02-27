//
//  SettingsViewController.swift
//  Connect
//
//  Created by Subham Padhi on 26/02/19.
//  Copyright © 2019 Subham Padhi. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        if Auth.auth().currentUser?.uid == nil {
            handleLogout()
        }
    }
    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.set(false, forKey: "Login")
        }catch let logOutError {
            print(logOutError)
        }
        
        let vc = LoginVC()
        present(vc, animated: true, completion: nil)
    }
}




