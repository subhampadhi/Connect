//
//  AddUserVC.swift
//  Connect
//
//  Created by Subham Padhi on 28/02/19.
//  Copyright © 2019 Subham Padhi. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import CodableFirebase

class AddUserVC: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    var allUsers = [Users]()
    var keys = [String]()
    var selectedUser = Users()
    var selectedKey = String()
    var groupId : String?
    
    var usersTable: UITableView = {
        let view = UITableView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var addMemberButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.4078431373, green: 0.1176470588, blue: 0.4392156863, alpha: 1)
        button.titleLabel?.font = UIFont(name: "Nunito-SemiBold", size: 20)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(AddUserVC.addMember), for: .touchUpInside)
        return button
    }()
    
    @objc func addMember() {
        
        addGroupToUser()
        addUserToGroup()
    }
    
    func addUserToGroup () {
        
        let ref = Database.database().reference()
        ref.child("Groups").child(groupId!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            guard let value = snapshot.value else { return }
            
            do {
                let model = try FirebaseDecoder().decode(Groups.self, from: value)
                var members = model.Members
                if members == nil {
                    var memberArray = [String]()
                    memberArray.append(self.selectedKey)
                    print(memberArray)
                    ref.child("Groups").child(self.groupId!).updateChildValues(["Members" : memberArray])
                }else {
                    members?.append(self.selectedKey)
                    ref.child("Groups").child(self.groupId!).updateChildValues(["Members" : members])
                }
            } catch let error {
                print(error)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func addGroupToUser () {
        
        let ref = Database.database().reference()
        ref.child("users").child(selectedKey).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            guard let value = snapshot.value else { return }
            
            do {
                let model = try FirebaseDecoder().decode(Users.self, from: value)
                var groups = model.groups
                if groups == nil {
                    var groupArray = [String]()
                    groupArray.append(self.groupId!)
                    ref.child("users").child(self.selectedKey).updateChildValues(["groups" : groupArray])
                }else {
                    groups?.append(self.groupId!)
                    ref.child("users").child(self.selectedKey).updateChildValues(["groups" : groups])
                    print("Saved user into db")
                }
            } catch let error {
                print(error)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUser = allUsers[indexPath.row]
        selectedKey = keys[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setupViews()
        getAllUsers()
    }
    
    func getAllUsers() {
        keys.removeAll()
        let ref = Database.database().reference()
        ref.child("users").observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let postKey = snap.key
                self.keys.append(postKey)
            }
            
            for key in self.keys {
                ref.child("users").child(key).observeSingleEvent(of: .value) { (snapshot) in
                    guard let value = snapshot.value else { return }
                    do{
                        let model = try FirebaseDecoder().decode(Users.self, from: value)
                        self.allUsers.append(model)
                        DispatchQueue.main.async {
                            self.usersTable.reloadData()
                        }
                    } catch let err {
                        print(err)
                    }
                    
                }
            }
        }
        
        
    }
    
    func setupViews() {
        
        view.addSubview(usersTable)
        view.addSubview(addMemberButton)
        
        usersTable.dataSource = self
        usersTable.delegate = self
        
        usersTable.register(UserCell.self, forCellReuseIdentifier: "userCell")
        
        if #available(iOS 11.0, *) {
            addMemberButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            addMemberButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        addMemberButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        addMemberButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        addMemberButton.heightAnchor.constraint(equalToConstant: 51).isActive = true
        
        usersTable.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        usersTable.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        usersTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        usersTable.bottomAnchor.constraint(equalTo: addMemberButton.topAnchor).isActive = true
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if keys.count != 0  {
            return allUsers.count
        }else {
            return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! UserCell
            let user = allUsers[indexPath.row]
            cell.userEmailLabel.text = user.email
            cell.userNameLabel.text = user.name
            return cell
        }
}

class UserCell: UITableViewCell{
    
    var profileImage: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.contentMode = UIView.ContentMode.scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    let userNameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(16)
        label.text = "Subham Padhi"
        label.textColor = #colorLiteral(red: 0.4078431373, green: 0.1176470588, blue: 0.4392156863, alpha: 1)
        return label
    }()
    
    let userEmailLabel : UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(12)
        label.text = "subhampadhi15@gmail.com"
        label.textColor = #colorLiteral(red: 0.4078431373, green: 0.1176470588, blue: 0.4392156863, alpha: 1)
        return label
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        initViews()
    }
    
    func initViews() {
        
        addSubview(userNameLabel)
        addSubview(userEmailLabel)
        addSubview(profileImage)
        
        profileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        profileImage.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        userNameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 15).isActive = true
        userNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        userNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        
        userEmailLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 15).isActive = true
        userEmailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        userEmailLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 10).isActive = true
    }
}

