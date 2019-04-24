//
//  JoinGroupVC.swift
//  Connect
//
//  Created by Subham Padhi on 08/04/19.
//  Copyright © 2019 Subham Padhi. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth
import CodableFirebase

class JoinGroupVC: UIViewController {
    
    var groupInfo = Groups()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setUpViews()
    }
    
    var profileImage: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        view.contentMode = UIView.ContentMode.scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    var groupName : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "IBMPlexSans-SemiBoldItalic", size: 16)
        label.textColor = #colorLiteral(red: 0.4078431373, green: 0.1176470588, blue: 0.4392156863, alpha: 1)
        label.text = "The best Group Ever"
        return label
    }()
    
    var aboutLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "IBMPlexSans-SemiBold", size: 16)
        label.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        label.text = "A B O U T"
        return label
    }()
    
    var DescriptionLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "IBMPlexSans-Medium", size: 16)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.numberOfLines = 0
        return label
    }()
    
    var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()


    var submitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.4078431373, green: 0.1176470588, blue: 0.4392156863, alpha: 1)
        button.titleLabel?.font = UIFont(name: "Nunito-SemiBold", size: 20)
        button.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        button.addTarget(self, action: #selector(JoinGroupVC.joinGroupPressed), for: .touchUpInside)
        return button
    }()
    
    @objc func joinGroupPressed() {
        
        let ref = Database.database().reference().child("Groups")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            for child in snapshot.children {
                let planSnap = child as! DataSnapshot
                let planDict = planSnap.value as! [String: Any]
                let name = planDict["Group_Name"] as! String
                let description = planDict["Description"] as! String
                if name == self.groupInfo.Group_Name && description == self.groupInfo.Description {
                    self.joinGroup(groupId: planSnap.key)
                }
            }
        })
    }
    
    func joinGroup(groupId:String) {
        
        let ref = Database.database().reference()
        ref.child("Groups").child(groupId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let value = snapshot.value else { return }
            
            do {
                let model = try FirebaseDecoder().decode(Groups.self, from: value)
                var members = model.Members
                if members == nil {
                    var memberArray = [String]()
                    guard let userID = Auth.auth().currentUser?.uid else {return}
                    memberArray.append(userID)
                   memberArray = memberArray.removeDuplicates()
                    print(memberArray)
                    ref.child("Groups").child(groupId).updateChildValues(["Members" : memberArray])
                }else {
                    guard let userID = Auth.auth().currentUser?.uid else {return}
                    members?.append(userID)
                    members = members!.removeDuplicates()
                    ref.child("Groups").child(groupId).updateChildValues(["Members" : members])
                }
            } catch let error {
                print(error)
            }
        }) { (error) in
            Utils.showAlert(title: "Oopd", message: error.localizedDescription, presenter: self)
        }
        
        let userRef = Database.database().reference()
        guard let userID = Auth.auth().currentUser?.uid else {return}
        userRef.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            guard let value = snapshot.value else { return }
            
            do {
                let model = try FirebaseDecoder().decode(Users.self, from: value)
                var groups = model.groups
                if groups == nil {
                    var groupArray = [String]()
                    groupArray.append(groupId)
                    ref.child("users").child(userID).updateChildValues(["groups" : groupArray])
                }else {
                    groups?.append(groupId)
                    ref.child("users").child(userID).updateChildValues(["groups" : groups])
                    print("Saved user into db")
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
    
    override func viewDidAppear(_ animated: Bool) {
        scrollView.updateContentViewSize()
        
    }
    
    func setUpViews() {
        
        view.addSubview(scrollView)
        view.addSubview(submitButton)
        scrollView.addSubview(profileImage)
        scrollView.addSubview(groupName)
        scrollView.addSubview(aboutLabel)
        scrollView.addSubview(DescriptionLabel)
        
        submitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        if #available(iOS 11.0, *) {
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            submitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        if #available(iOS 11.0, *) {
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: submitButton.topAnchor).isActive = true
        
        profileImage.topAnchor.constraint(equalTo: scrollView.topAnchor , constant: 25).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 120).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 120).isActive = true
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImage.layer.cornerRadius = 60
        
        groupName.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        groupName.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 10).isActive = true
        groupName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        groupName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        groupName.textAlignment = .center
        
        aboutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        aboutLabel.topAnchor.constraint(equalTo: groupName.bottomAnchor, constant: 25).isActive = true
        
        DescriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        DescriptionLabel.topAnchor.constraint(equalTo: aboutLabel.topAnchor, constant: 35).isActive = true
        DescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        DescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        DescriptionLabel.textAlignment = .center
        
        groupName.text = groupInfo.Group_Name
        DescriptionLabel.text = groupInfo.Description
        
        if groupInfo.PrivateGroup == "true" {
            submitButton.setTitle("You can't Join a closed group", for: .normal)
        } else {
            submitButton.setTitle("Join", for: .normal) 
        }
        
    }

    
    
}

extension UIScrollView {
    func updateContentViewSize() {
        var newHeight: CGFloat = 0
        for view in subviews {
            let ref = view.frame.origin.y + view.frame.height
            if ref > newHeight {
                newHeight = ref
            }
        }
        let oldSize = contentSize
        let newSize = CGSize(width: oldSize.width, height: newHeight + 30)
        contentSize = newSize
    }
}

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
}
