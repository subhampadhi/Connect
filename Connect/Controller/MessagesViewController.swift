//
//  MessagesViewController.swift
//  Connect
//
//  Created by Subham Padhi on 26/02/19.
//  Copyright © 2019 Subham Padhi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import CodableFirebase

class MessagesViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    var userInfo: Users?
    var isReady = false
    var groupIds : [String]?
    var groupInfoArray = [Groups]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        setUpViews()
        findGroupsForUser()
    }
    
     var messagesTable: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func findGroupsForUser() {
        
        let ref = Database.database().reference()
        
        guard let userID = Auth.auth().currentUser?.uid else {return}
        
        ref.child("users").child(userID).observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value else { return }
            
            do {
                let model = try FirebaseDecoder().decode(Users.self, from: value)
                self.userInfo = model
                self.groupIds = self.userInfo?.groups
                self.getGroupInfo()
            }catch let error {
                print(error)
            }
        })
    }
    
    func getGroupInfo()  {
        
        var groups:[String]?
        let ref = Database.database().reference()
        if groupIds?.count != nil {
        for ids in groupIds! {
            ref.child("Groups").child(ids).observeSingleEvent(of: .value , with: { (snapshot) in
                guard let value = snapshot.value else { return }
                
                do {
                    let model = try FirebaseDecoder().decode(Groups.self, from: value)
                    self.groupInfoArray.append(model)
                    self.isReady = true
                    DispatchQueue.main.async {
                        self.messagesTable.reloadData()
                    }
                } catch let error {
                    print(error)
                }
                
            })
        }
        }
    }
    
    func setUpViews() {
        
        view.addSubview(messagesTable)
        
        messagesTable.dataSource = self
        messagesTable.delegate = self
        
        messagesTable.register(HeaderCell.self, forCellReuseIdentifier: "headerCell")
        messagesTable.register(MessagesCell.self, forCellReuseIdentifier: "messagesCell")
        
        messagesTable.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        messagesTable.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        messagesTable.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        if #available(iOS 11.0, *) {
            messagesTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            messagesTable.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 150
        } else {
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isReady {
            if groupInfoArray.count != nil {
                return groupInfoArray.count + 1
                
            } else {
                return 1
            }
            
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            return
        } else {
            let vc = ChatScreenVC()
            vc.userInfo = self.userInfo
            vc.groupInfo = groupInfoArray[indexPath.row - 1]
            vc.groupId = groupIds![indexPath.row - 1]
            print(groupIds![indexPath.row - 1])
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderCell
            cell.selectionStyle = .none
            cell.addItem = {
                () in
              //  let vc = CreateGroupVC()
                let vc = CreateGroupVC()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "messagesCell") as! MessagesCell
            cell.selectionStyle = .none
            cell.groupNameLabel.text = groupInfoArray[indexPath.row - 1].Group_Name
            return cell
        }
        
    }
    
    
}

class HeaderCell: UITableViewCell{
    
    var addItem: (() -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
    }
    
    var headerLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Messages"
        label.font = UIFont(name: "IBMPlexSans-Light", size: 50)
        label.textColor = #colorLiteral(red: 0.4078431373, green: 0.1176470588, blue: 0.4392156863, alpha: 1)
        return label
    }()
    
    var PlusLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "+"
        label.textAlignment = .left
        label.font = label.font.withSize(80)
        label.textColor = #colorLiteral(red: 0.4078431373, green: 0.1176470588, blue: 0.4392156863, alpha: 1)
        return label
    }()
    
    @objc func plusTapped(){
        addItem?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(PlusLabel)
        addSubview(headerLabel)
        
        PlusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
        PlusLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        
        headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        headerLabel.topAnchor.constraint(equalTo: PlusLabel.bottomAnchor , constant: -20).isActive = true
        
        let plusTap = UITapGestureRecognizer(target: self, action: #selector(HeaderCell.plusTapped))
        PlusLabel.addGestureRecognizer(plusTap)
        PlusLabel.isUserInteractionEnabled = true
        
        
    }
}

class MessagesCell: UITableViewCell{
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
    }
    
    var backgroundCardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 40
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.clipsToBounds = false
        view.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        return view
    }()
    
    var groupImage : UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.4078431373, green: 0.1176470588, blue: 0.4392156863, alpha: 1)
        view.layer.cornerRadius = 35
        return view
    }()
    
    var groupNameLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "IBMPlexSans-SemiBoldItalic", size: 16)
        label.textColor = #colorLiteral(red: 0.4078431373, green: 0.1176470588, blue: 0.4392156863, alpha: 1)
        return label
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(backgroundCardView)
        backgroundCardView.addSubview(groupNameLabel)
        backgroundCardView.addSubview(groupImage)
        
        
        
        backgroundCardView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        backgroundCardView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        backgroundCardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        backgroundCardView.trailingAnchor.constraint(equalTo: trailingAnchor , constant:-15).isActive = true
        
        groupImage.leadingAnchor.constraint(equalTo: backgroundCardView.leadingAnchor, constant: 5).isActive = true
        groupImage.centerYAnchor.constraint(equalTo: backgroundCardView.centerYAnchor).isActive = true
        groupImage.heightAnchor.constraint(equalToConstant: 70).isActive = true
        groupImage.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        groupNameLabel.centerXAnchor.constraint(equalTo: backgroundCardView.centerXAnchor).isActive = true
        groupNameLabel.topAnchor.constraint(equalTo: backgroundCardView.topAnchor, constant: 15).isActive = true
    }
}
