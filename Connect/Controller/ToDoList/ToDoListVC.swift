//
//  ToDoListVC.swift
//  Connect
//
//  Created by Subham Padhi on 05/04/19.
//  Copyright © 2019 Subham Padhi. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth
import CodableFirebase

class ToDoListVC : UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    var groupId : String?
    var isTodoCreated = Bool()
    var isReady = false
    var toDoList = [TodoItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        titleLabel.text = "To Do List"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Nunito-Bold", size: 18)
        titleLabel.textColor = #colorLiteral(red: 0, green: 0.4352941176, blue: 0.9529411765, alpha: 1)
        navigationItem.titleView = titleLabel
        setUpViews()
        observeList()
    }
    
    var toDoTable: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var floatingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.4078431373, green: 0.1176470588, blue: 0.4392156863, alpha: 1)
        button.contentMode = .scaleAspectFit
        button.setImage(#imageLiteral(resourceName: "Add"), for: .normal)
        button.addTarget(self, action: #selector(ToDoListVC.addToListPressed), for: .touchUpInside)
        return button
    }()
    
    func observeList() {
        
        let ref = Database.database().reference().child("ToDoList").child(groupId!)
        ref.observe(.childAdded, with: { (snapshot) in
            guard let value = snapshot.value else { return }
            do {
                let model = try FirebaseDecoder().decode(TodoItem.self, from: value)
                self.toDoList.append(model)
                self.isReady = true
                DispatchQueue.main.async {
                    self.toDoTable.reloadData()
                }
            } catch let error {
                print(error)
            }
        }, withCancel: nil)
    }
    func setUpViews() {
        
        toDoTable.dataSource = self
        toDoTable.delegate = self
        
        
        view.addSubview(toDoTable)
        toDoTable.addSubview(floatingButton)
        
        toDoTable.register(ListCell.self, forCellReuseIdentifier: "listCell")
        
        
        toDoTable.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        toDoTable.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        toDoTable.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        if #available(iOS 11.0, *) {
            toDoTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
         } else {
            toDoTable.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        
        floatingButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        floatingButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        floatingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        if #available(iOS 11.0, *) {
            floatingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        } else {
            floatingButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15).isActive = true
        }
        floatingButton.layer.cornerRadius = 25
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isReady {
            return toDoList.count
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isReady {
            let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as! ListCell
            cell.selectionStyle = .none
            cell.workLabel.text = toDoList[indexPath.row].title
            if toDoList[indexPath.row].completed! {
                cell.workLabel.attributedText = strikeThroughText(toDoList[indexPath.row].title!)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as! ListCell
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 15))
        view.backgroundColor = .white
        
        
        let progressBar = UIProgressView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 10))
        progressBar.layer.masksToBounds = true
        progressBar.backgroundColor = .white
        progressBar.trackTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        progressBar.progressTintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        
        let progress = updateProgressBar()
        progressBar.progress = progress
        
        
        view.addSubview(progressBar)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    
    @objc func addToListPressed() {
        
        let addAlert = UIAlertController(title: "New Todo", message: "Enter a title", preferredStyle: .alert)
        addAlert.addTextField { (textfield:UITextField) in
            textfield.placeholder = "ToDo Item Title"
        }
        
        addAlert.addAction(UIAlertAction(title: "Create", style: .default, handler: { (action:UIAlertAction) in
            guard let title = addAlert.textFields?.first?.text else { return }
            
            let newTodo = TodoItem(title: title, completed: false, createdAt: self.getDateTime())
            self.createList(toDoItem: newTodo)

        }))
        
        addAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(addAlert, animated: true, completion: nil)
    }
    
    func createList(toDoItem: TodoItem)  {
        
        let ref = Database.database().reference().child("ToDoList").child(groupId!)
        
        let childRef = ref.childByAutoId()
        let values = ["title": "\(toDoItem.title!)", "completed": false , "date" : getDateTime()] as [String : Any]
        childRef.updateChildValues(values) { (error, childRef) in
            if error != nil {
                Utils.showAlert(title: "oops!", message: "\((error!))", presenter: self)
            }
        }
        let reference = Database.database().reference().child("Groups").child(groupId!)
        reference.updateChildValues(["ToDoList": "true"])
    }
    
    func getDateTime() -> String {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        let dateTime = formatter.string(from: currentDateTime)
        return dateTime
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        completeTodoItem(indexPath)
        
    }
    func updateWorkCompletion(_ indexPath:IndexPath) {
        
         let ref = Database.database().reference().child("ToDoList").child(groupId!)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            for child in snapshot.children {
                let planSnap = child as! DataSnapshot
                let planDict = planSnap.value as! [String: Any]
                let title = planDict["title"] as! String
                if title == self.toDoList[indexPath.row].title {
                    ref.child(planSnap.key).updateChildValues(["completed": true])
                }
                
            }
        })
        toDoList[indexPath.row].completed! = true
       // updateProgressBar()
        toDoTable.reloadSections(IndexSet(0..<1), with: .automatic)
    }
    
    func updateProgressBar() -> Float {
        
        if toDoList.isEmpty {
            return 0
        }
        var doneCount = 0
        for values in toDoList {
            if(values.completed!){
                doneCount+=1
            }
        }
         let doneRatio = Float(doneCount)/Float(toDoList.count)
        return doneRatio
        
    }
    
    
    func completeTodoItem(_ indexPath:IndexPath) {
        var todoItem = toDoList[indexPath.row]
        updateWorkCompletion(indexPath)
       // toDoList[indexPath.row] = todoItem
        
        if let cell = toDoTable.cellForRow(at: indexPath) as? ListCell {
            cell.workLabel.attributedText = strikeThroughText(todoItem.title!)
            
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = cell.transform.scaledBy(x: 1.5, y: 1.5)
            }, completion: { (success) in
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    cell.transform = CGAffineTransform.identity
                }, completion: nil)
            })
            
        }
        
        
    }
    
    func strikeThroughText (_ text:String) -> NSAttributedString {
        let color = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        
        let attributedStringColor = [NSAttributedString.Key.foregroundColor : color]
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: text , attributes: attributedStringColor)
        
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        
        return attributeString
    }

    
}

class ListCell : UITableViewCell {
    
    
    var workLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "IBMPlexSans-BoldItalic", size: 18)
        label.text = "Subham Padhi"
        label.textColor = #colorLiteral(red: 0.4078431373, green: 0.1176470588, blue: 0.4392156863, alpha: 1)
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    func setUpView() {
        
        addSubview(workLabel)
        
        workLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        workLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        workLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
