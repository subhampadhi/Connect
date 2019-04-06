//
//  NotesTableVC.swift
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


class NotesTableVC: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    var groupId : String?
    var isNotesCreated = Bool()
    var isReady = false
    var notesList = [NotesItem]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let addUser = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addNotesPressed))
        if let font = UIFont(name: "Nunito-SemiBold", size: 16) {
            addUser.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        }
        self.navigationItem.rightBarButtonItem = addUser
        setUpViews()
        observeList()
    }
    
    func observeList() {
        
        let ref = Database.database().reference().child("Notes").child(groupId!)
        let refrence = Database.database().reference().child("Notes").child(groupId!)
        
        ref.observe(.childAdded, with: { (snapshot) in
            guard let value = snapshot.value else { return }
            do {
                let model = try FirebaseDecoder().decode(NotesItem.self, from: value)
                self.notesList.append(model)
                self.isReady = true
                DispatchQueue.main.async {
                    self.notesTable.reloadData()
                }
            } catch let error {
                print(error)
            }
        }, withCancel: nil)
        
        refrence.observe(.childChanged) { (snapshot) in
            
            ref.observe(.value, with: { (snapshot) in
                guard let value = snapshot.value else { return }
               
                do {
                    let model = try FirebaseDecoder().decode(NotesItem.self, from: value)
                    self.notesList.append(model)
                    self.isReady = true
                    DispatchQueue.main.async {
                        self.notesTable.reloadData()
                    }
                } catch let error {
                    print(error)
                }
            }, withCancel: nil)
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isReady {
            return notesList.count
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isReady {
            let cell = tableView.dequeueReusableCell(withIdentifier: "notesCell") as! ListCell
            cell.selectionStyle = .none
            cell.workLabel.text = notesList[indexPath.row].title
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "notesCell") as! ListCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = NotesScreenVC()
        vc.isNewNote = false
        vc.groupId = self.groupId
        vc.notes = self.notesList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    var notesTable: UITableView = {
        let view = UITableView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setUpViews() {
        
        notesTable.dataSource = self
        notesTable.delegate = self
        
         notesTable.register(ListCell.self, forCellReuseIdentifier: "notesCell")
        
        view.addSubview(notesTable)
        
        notesTable.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        notesTable.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        notesTable.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        if #available(iOS 11.0, *) {
            notesTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            notesTable.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
    }
    
    @objc func addNotesPressed() {
    
    let vc = NotesScreenVC()
    vc.isNewNote = true
    vc.groupId = self.groupId
    self.navigationController?.pushViewController(vc, animated: true)
    }
}

