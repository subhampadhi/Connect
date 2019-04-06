//
//  NotesScreenVC.swift
//  Connect
//
//  Created by Subham Padhi on 06/04/19.
//  Copyright © 2019 Subham Padhi. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth
import CodableFirebase

class NotesScreenVC: UIViewController , UITextViewDelegate {
    
    var isNewNote = Bool()
    var groupId : String?
    var notes = NotesItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let addUser = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveNotesPressed))
        if let font = UIFont(name: "Nunito-SemiBold", size: 16) {
            addUser.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        }
        self.navigationItem.rightBarButtonItem = addUser

        
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        setupViews()
    }
    
    @objc func saveNotesPressed() {
       
        guard let title = titleField.text, title != "" else {
            Utils.showAlert(title: "Title cannot be empty.", message: "Please provide a Title..", presenter: self)
            return
        }
        
        guard let description = descriptionField.text, description != "" else {
            Utils.showAlert(title: "Description cannot be empty.", message: "Please provide a description..", presenter: self)
            return
        }
        
        guard let createdAt = dateLabel.text, createdAt != "" else {
            Utils.showAlert(title: "Description cannot be empty.", message: "Please provide a description..", presenter: self)
            return
        }
        
        let newNote = NotesItem(title: title, description: description, createdAt:createdAt )
        if isNewNote {
        if (saveNote(notesItem: newNote)) {
            navigationController?.popViewController(animated: true)
            
        } else {
            return
            }
            
        } else {
            if (editNote(notesItem: newNote)) {
                navigationController?.popViewController(animated: true)
                
            } else {
                return
            }
        }
        
    }
    
    func editNote(notesItem: NotesItem) -> Bool {
        
        let ref = Database.database().reference().child("Notes").child(groupId!)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            for child in snapshot.children {
                let planSnap = child as! DataSnapshot
                let planDict = planSnap.value as! [String: Any]
                let title = planDict["title"] as! String
                let date =  planDict["createdAt"] as! String
                if date == self.notes.createdAt {
                    ref.child(planSnap.key).updateChildValues(["title": "\(notesItem.title!)", "description": "\(notesItem.description!)" , "createdAt" : notesItem.createdAt])
                }
                
            }
        })
        
        return true
    }
    
    func saveNote(notesItem: NotesItem) -> Bool {
        var result = true
        let ref = Database.database().reference().child("Notes").child(groupId!)
        
        let childRef = ref.childByAutoId()
        let values = ["title": "\(notesItem.title!)", "description": "\(notesItem.description!)" , "createdAt" : notesItem.createdAt] as [String : Any]
        childRef.updateChildValues(values) { (error, childRef) in
            if error != nil {
                result = false
                Utils.showAlert(title: "oops!", message: "\((error!))", presenter: self)
            } 
        }
        let reference = Database.database().reference().child("Groups").child(groupId!)
        reference.updateChildValues(["Notes": "true"])
        
        return result
    }
    
    
    var dateLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "IBMPlexSans-SemiBoldItalic", size: 16)
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        return label
    }()
    
    lazy var titleField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.placeholder = "Write Title subject here..."
        view.font = UIFont(name: "IBMPlexSans-SemiBoldItalic", size: 16)
        return view
    }()
    
    lazy var descriptionField: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "IBMPlexSans-SemiBoldItalic", size: 13)
        view.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.borderWidth = 1.0
        return view
    }()
    
    var placeholderLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = NSTextAlignment.left
        view.text = "Describe your complain..."
        view.numberOfLines = 0
        view.textColor = #colorLiteral(red: 0.5960784314, green: 0.5960784314, blue: 0.5960784314, alpha: 1)
        view.font = UIFont(name: "IBMPlexSans-SemiBoldItalic", size: 12)
        return view
    }()
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !descriptionField.text.isEmpty
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func setupViews() {
        descriptionField.delegate = self
        view.addSubview(dateLabel)
        view.addSubview(titleField)
        view.addSubview(descriptionField)
        
        dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if isNewNote {
            dateLabel.text = Utils.getDateTime()
        } else {
            dateLabel.text = notes.createdAt
        }
        
        titleField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        titleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        titleField.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 15).isActive = true
        
        descriptionField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        descriptionField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        descriptionField.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 10).isActive = true
        descriptionField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        
        descriptionField.addSubview(placeholderLabel)
        placeholderLabel.leadingAnchor.constraint(equalTo: descriptionField.leadingAnchor, constant: 10).isActive = true
        placeholderLabel.trailingAnchor.constraint(equalTo: descriptionField.trailingAnchor, constant: -10).isActive = true
        placeholderLabel.topAnchor.constraint(equalTo: descriptionField.topAnchor, constant: 10).isActive = true
        placeholderLabel.isHidden = !descriptionField.text.isEmpty
        
        if !isNewNote {
            titleField.text = notes.title
            descriptionField.text = notes.description
            placeholderLabel.isHidden = !descriptionField.text.isEmpty
        }
        
    }
}
