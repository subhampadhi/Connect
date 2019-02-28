//
//  AddUserVC.swift
//  Connect
//
//  Created by Subham Padhi on 28/02/19.
//  Copyright © 2019 Subham Padhi. All rights reserved.
//

import UIKit

class AddUserVC: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
   
    
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
        button.addTarget(self, action: #selector(CreateGroupVC.createGroups), for: .touchUpInside)
        return button
    }()
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setupViews()
    }
    
    func setupViews() {
        
        view.addSubview(usersTable)
        view.addSubview(addMemberButton)
        
        usersTable.dataSource = self
        usersTable.delegate = self
        
        usersTable.register(UserCell.self, forCellReuseIdentifier: "userCell")
        usersTable.register(IncommingChatMessageCell.self, forCellReuseIdentifier: "incommingChatMessageCell")
        usersTable.register(OutgoingChatMessageCell.self, forCellReuseIdentifier: "outgoingChatMessageCell")
        
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
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "outgoingChatMessageCell") as! OutgoingChatMessageCell
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

