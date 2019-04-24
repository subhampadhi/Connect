//
//  SettingsViewController.swift
//  Connect
//
//  Created by Subham Padhi on 26/02/19.
//  Copyright © 2019 Subham Padhi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseAuth
import CodableFirebase

class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        if Auth.auth().currentUser?.uid == nil {
            handleLogout()
        
        
        }
    }
        
    
    
    var sendButton: UIButton = {
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: UIControl.State())
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return sendButton
    }()
    
    @objc func handleSend() {
        
        let vc = CreatePaymentModule()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.set(false, forKey: "Login")
            let vc = LoginVC()
            present(vc, animated: true, completion: nil)
        }catch let logOutError {
            print(logOutError)
        }
        
        
    }
}




