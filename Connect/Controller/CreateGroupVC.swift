//
//  AddUserVC.swift
//  Connect
//
//  Created by Subham Padhi on 27/02/19.
//  Copyright © 2019 Subham Padhi. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import CodableFirebase

class CreateGroupVC: UIViewController {
    
    var groupArrayValues : [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        initViews()
    }
    
    var groupNameLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Group Name"
        label.font = label.font.withSize(20)
        label.textColor = #colorLiteral(red: 0.4078431373, green: 0.1176470588, blue: 0.4392156863, alpha: 1)
        return label
    }()
    
    var groupNameText: UITextField = {
        let nameText = UITextField()
        nameText.translatesAutoresizingMaskIntoConstraints = false
        nameText.attributedPlaceholder = NSAttributedString(text: " (required)", aligment: .left)
        nameText.setPadding()
        nameText.setBottomBorder(backGroundColor: #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1), borderColor: #colorLiteral(red: 0.4078431373, green: 0.1176470588, blue: 0.4392156863, alpha: 1))
        nameText.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        nameText.font = nameText.font?.withSize(14)
        return nameText
    }()
    
    var groupInfoLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Group Info"
        label.textColor = #colorLiteral(red: 0.4078431373, green: 0.1176470588, blue: 0.4392156863, alpha: 1)
        label.font = label.font.withSize(20)
        return label
    }()
    
    var groupInfoText: UITextField = {
        let nameText = UITextField()
        nameText.translatesAutoresizingMaskIntoConstraints = false
        nameText.attributedPlaceholder = NSAttributedString(text: " (optional)", aligment: .left)
        nameText.setPadding()
        nameText.setBottomBorder()
        nameText.font = nameText.font?.withSize(14)
        nameText.setBottomBorder(backGroundColor: #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1), borderColor: #colorLiteral(red: 0.4078431373, green: 0.1176470588, blue: 0.4392156863, alpha: 1))
        
        return nameText
    }()
    
    var createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.4078431373, green: 0.1176470588, blue: 0.4392156863, alpha: 1)
        button.titleLabel?.font = UIFont(name: "Nunito-SemiBold", size: 20)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(CreateGroupVC.createGroups), for: .touchUpInside)
        return button
    }()
    
    @objc func createGroups() {
        
        guard let groupName = groupNameText.text , let groupInfoText = groupInfoText.text else { return }
        
        
        let ref = Database.database().reference()
        
        guard let userID = Auth.auth().currentUser?.uid else {return}
        
        let groupRefrence = ref.child("Groups").childByAutoId()
        let groupId = groupRefrence.key
        
        let values = ["Group_Name":groupName , "Description": groupInfoText , "Members":["\(userID)"] , "ToDoList" : "False" , "Notes": "False"] as [String : Any]
        groupRefrence.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err!)
                return
            } else {
                
            }
        })
        
        ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            guard let value = snapshot.value else { return }
            
            do {
                let model = try FirebaseDecoder().decode(Users.self, from: value)
                var groups = model.groups
                if groups == nil {
                    var groupArray = [String]()
                    groupArray.append(groupId!)
                    ref.child("users").child(userID).updateChildValues(["groups" : groupArray])
                }else {
                groups?.append(groupId!)
                ref.child("users").child(userID).updateChildValues(["groups" : groups])
                print("Saved user into db")
                    self.navigationController?.popViewController(animated: true)
                }
            } catch let error {
                print(error)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func initViews() {
        
        view.addSubview(createButton)
        view.addSubview(groupNameLabel)
        view.addSubview(groupNameText)
        view.addSubview(groupInfoLabel)
        view.addSubview(groupInfoText)
        
        groupNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        groupNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:15).isActive = true
        groupNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-15).isActive = true
        
        groupNameText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:15).isActive = true
        groupNameText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-15).isActive = true
        groupNameText.topAnchor.constraint(equalTo: groupNameLabel.bottomAnchor, constant: 10).isActive = true
        
        groupInfoLabel.topAnchor.constraint(equalTo: groupNameText.bottomAnchor, constant: 30).isActive = true
        groupInfoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:15).isActive = true
        groupInfoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-15).isActive = true
        
        groupInfoText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:15).isActive = true
        groupInfoText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-15).isActive = true
        groupInfoText.topAnchor.constraint(equalTo: groupInfoLabel.bottomAnchor, constant: 10).isActive = true
        
        
        
        if #available(iOS 11.0, *) {
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            createButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        createButton.heightAnchor.constraint(equalToConstant: 51).isActive = true
        
    }
    
    
}
