//
//  GroupVC.swift
//  Connect
//
//  Created by Subham Padhi on 01/03/19.
//  Copyright © 2019 Subham Padhi. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import CodableFirebase

class ChatScreenVC: UIViewController, UITextFieldDelegate , UITableViewDelegate , UITableViewDataSource {
    
    var groupInfo : Groups?
    var userInfo: Users?
    var groupId : String?
    var allMessages = [Messages]()
    var isReady = false
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    var messagesTable: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "\((groupInfo?.Group_Name)!)"
        view.backgroundColor = UIColor.white
        
        setupInputComponents()
        observeMessages()
    }
    
    func observeMessages() {
        
        let ref = Database.database().reference().child("Groups").child(groupId!).child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            guard let value = snapshot.value else { return }
            do {
                let model = try FirebaseDecoder().decode(Messages.self, from: value)
                self.allMessages.append(model)
                print(self.allMessages.count)
                self.isReady = true
                
            } catch let error {
                print(error)
            }
        }, withCancel: nil)
    }
    
    func setupInputComponents() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: UIControl.State())
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        containerView.addSubview(inputTextField)
        
        
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        
        
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    @objc func handleSend() {
        
        guard let message = inputTextField.text else {
            return
        }
        let ref = Database.database().reference().child("Groups").child(groupId!).child("messages")
        
        let childRef = ref.childByAutoId()
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let values = ["text": message, "sender_name": "\((userInfo?.name)!)" , "uid": userID , "date" : getDateTime()]
        childRef.updateChildValues(values)
    }
    
    func getDateTime() -> String {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        let dateTime = formatter.string(from: currentDateTime)
        return dateTime
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isReady {
            return self.allMessages.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
