//
//  CreatePaymentModule.swift
//  Connect
//
//  Created by Subham Padhi on 11/04/19.
//  Copyright © 2019 Subham Padhi. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class CreatePaymentModule: UIViewController {
    
    var groupId : String?
    var isEdit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setUpViews()
    }
    
    var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var submitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.4078431373, green: 0.1176470588, blue: 0.4392156863, alpha: 1)
        button.setTitle("Create", for: .normal)
        button.titleLabel?.font = UIFont(name: "Nunito-SemiBold", size: 20)
        button.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        button.addTarget(self, action: #selector(CreatePaymentModule.createpayment), for: .touchUpInside)
        return button
    }()
    
    var memberIDLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Enter merchant id"
        label.font = label.font.withSize(20)
        label.textColor = #colorLiteral(red: 0.4078431373, green: 0.1176470588, blue: 0.4392156863, alpha: 1)
        return label
    }()
    
    var secretKeyLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Enter secret key"
        label.font = label.font.withSize(20)
        label.textColor = #colorLiteral(red: 0.4078431373, green: 0.1176470588, blue: 0.4392156863, alpha: 1)
        return label
    }()
    
    var memberIDText: UITextField = {
        let nameText = UITextField()
        nameText.translatesAutoresizingMaskIntoConstraints = false
        nameText.attributedPlaceholder = NSAttributedString(text: " (required)", aligment: .left)
        nameText.setPadding()
        nameText.setBottomBorder(backGroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0.4078431373, green: 0.1176470588, blue: 0.4392156863, alpha: 1))
        nameText.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        nameText.font = nameText.font?.withSize(14)
        return nameText
    }()
    
    var secretKeyText: UITextField = {
        let nameText = UITextField()
        nameText.translatesAutoresizingMaskIntoConstraints = false
        nameText.attributedPlaceholder = NSAttributedString(text: " (required)", aligment: .left)
        nameText.setPadding()
        nameText.setBottomBorder(backGroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0.4078431373, green: 0.1176470588, blue: 0.4392156863, alpha: 1))
        nameText.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        nameText.font = nameText.font?.withSize(14)
        return nameText
    }()
    
    var capitalToRaiseLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Enter amount to raise in INR"
        label.font = label.font.withSize(20)
        label.textColor = #colorLiteral(red: 0.4078431373, green: 0.1176470588, blue: 0.4392156863, alpha: 1)
        return label
    }()
    
    var capitalToRaiseText: UITextField = {
        let nameText = UITextField()
        nameText.translatesAutoresizingMaskIntoConstraints = false
        nameText.attributedPlaceholder = NSAttributedString(text: " (optional)", aligment: .left)
        nameText.setPadding()
        nameText.setBottomBorder(backGroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0.4078431373, green: 0.1176470588, blue: 0.4392156863, alpha: 1))
        nameText.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        nameText.keyboardType = .numberPad
        nameText.font = nameText.font?.withSize(14)
        return nameText
    }()
    
    func payment() {
        var isTargetSet = true
        if !isEdit {
            
            guard let memberID = memberIDText.text, memberID != "" else {
                Utils.showAlert(title: "Title cannot be empty.", message: "Please provide a Title..", presenter: self)
                return
            }
            
            guard let secretKeyText = secretKeyText.text, secretKeyText != "" else {
                Utils.showAlert(title: "Description cannot be empty.", message: "Please provide a description..", presenter: self)
                return
            }
            
            let capitalToRaiseText = self.capitalToRaiseText.text
            
            if capitalToRaiseText == "" {
                isTargetSet = true
            }
            
            let ref = Database.database().reference()
            let values = ["Member_ID":memberID , "SecretKey": secretKeyText , "Capital_To_Raise":capitalToRaiseText ?? 0 , "IS_Target_Set":isTargetSet] as [String : Any]
            
            ref.child("Payment").child(self.groupId!).updateChildValues(values, withCompletionBlock: { (err, ref) in
                
                if err != nil {
                    Utils.showAlert(title: "Oops", message: (err?.localizedDescription)!, presenter: self)
                    return
                } else {
                    let reference = Database.database().reference().child("Groups").child(self.groupId!)
                    reference.updateChildValues(["Payment": "true"])
                    Utils.showAlertWithAction(title: "Success", message: "Your Payment module has been set", presenter: self)
                }
            })
            
        }
    }
    
    
    @objc func createpayment() {
        payment()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollView.updateContentViewSize()
    }
    
    func setUpViews() {
        
        view.addSubview(scrollView)
        view.addSubview(submitButton)
        view.addSubview(secretKeyLabel)
        view.addSubview(secretKeyText)
        view.addSubview(memberIDLabel)
        view.addSubview(memberIDText)
        view.addSubview(capitalToRaiseLabel)
        view.addSubview(capitalToRaiseText)
        
        
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
        
        if #available(iOS 11.0, *) {
            memberIDLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        } else {
            memberIDLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        }
        memberIDLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:15).isActive = true
        memberIDLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-15).isActive = true
        
        memberIDText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:15).isActive = true
        memberIDText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-15).isActive = true
        memberIDText.topAnchor.constraint(equalTo: memberIDLabel.bottomAnchor, constant: 10).isActive = true
        
        secretKeyLabel.topAnchor.constraint(equalTo: memberIDText.bottomAnchor, constant: 30).isActive = true
        secretKeyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:15).isActive = true
        secretKeyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-15).isActive = true
        
        secretKeyText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:15).isActive = true
        secretKeyText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-15).isActive = true
        secretKeyText.topAnchor.constraint(equalTo: secretKeyLabel.bottomAnchor, constant: 10).isActive = true
        
        capitalToRaiseLabel.topAnchor.constraint(equalTo: secretKeyText.bottomAnchor, constant: 30).isActive = true
        capitalToRaiseLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:15).isActive = true
        capitalToRaiseLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-15).isActive = true
        
        capitalToRaiseText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:15).isActive = true
        capitalToRaiseText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-15).isActive = true
        capitalToRaiseText.topAnchor.constraint(equalTo: capitalToRaiseLabel.bottomAnchor, constant: 10).isActive = true
        
    }
}
