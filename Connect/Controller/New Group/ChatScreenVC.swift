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
    
    var chatTable: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let addUser = UIBarButtonItem(title: "Add Members", style: .plain, target: self, action: #selector(addUserPressed))
        if let font = UIFont(name: "Nunito-SemiBold", size: 16) {
            addUser.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        }
        self.navigationItem.rightBarButtonItem = addUser

        
        navigationItem.title = "\((groupInfo?.Group_Name)!)"
        view.backgroundColor = UIColor.white
        
        setupInputComponents()
        observeMessages()
    }
    
    @objc func addUserPressed() {
        let vc = AddUserVC()
         vc.groupId  = self.groupId 
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func observeMessages() {
        
        let ref = Database.database().reference().child("Groups").child(groupId!).child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            guard let value = snapshot.value else { return }
            do {
                let model = try FirebaseDecoder().decode(Messages.self, from: value)
                self.allMessages.append(model)
                self.isReady = true
                DispatchQueue.main.async {
                    self.chatTable.reloadData()
                    self.scrollToBottom()
                }
            } catch let error {
                print(error)
            }
        }, withCancel: nil)
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.allMessages.count-1, section: 0)
            self.chatTable.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    var sendButton: UIButton = {
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: UIControl.State())
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return sendButton
    }()
    
    var addActionButton: UIButton = {
        
        let sendButton = UIButton(type: .system)
        sendButton.setImage(#imageLiteral(resourceName: "Add"), for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        sendButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        return sendButton
    }()

    func setupInputComponents() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        chatTable.dataSource = self
        chatTable.delegate = self
        
        view.addSubview(containerView)
        view.addSubview(chatTable)
        
        chatTable.register(IncommingChatMessageCell.self, forCellReuseIdentifier: "incommingChatMessageCell")
        chatTable.register(OutgoingChatMessageCell.self, forCellReuseIdentifier: "outgoingChatMessageCell")
        
        
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        if #available(iOS 11.0, *) {
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        chatTable.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        chatTable.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        if #available(iOS 11.0, *) {
            chatTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            chatTable.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }
        chatTable.bottomAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        
        containerView.addSubview(sendButton)
        containerView.addSubview(addActionButton)
        
        sendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant:50).isActive = true
        

        
        addActionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        addActionButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        addActionButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        addActionButton.heightAnchor.constraint(equalToConstant:80).isActive = true
        
        containerView.addSubview(inputTextField)
        
        inputTextField.leadingAnchor.constraint(equalTo: addActionButton.trailingAnchor).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor , constant: -5).isActive = true
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
    
    @objc func addAction() {
        let actionSheet = UIAlertController(title: "Modules", message: "Choose from the list of modules", preferredStyle: .actionSheet)
        
       
            actionSheet.addAction(UIAlertAction(title: "Create Notes", style: .default, handler: { (action: UIAlertAction) in
                self.CreateNotes()
            }))
        
            actionSheet.addAction(UIAlertAction(title: "Create To Do List", style: .default, handler: { (action: UIAlertAction) in
                self.CreateToDoList()
            }))
        
        if (groupInfo!.Payment == nil || groupInfo?.Payment == "false") {
            actionSheet.addAction(UIAlertAction(title: "Create Payments", style: .default, handler: { (action: UIAlertAction) in
                self.createPayment()
            }))
            
        } else {
            actionSheet.addAction(UIAlertAction(title: "Payment", style: .default, handler: { (action: UIAlertAction) in
                self.openPayScreen()
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func createPayment() {
        let vc = CreatePaymentModule()
        vc.groupId = self.groupId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func openPayScreen() {
        let vc = PaymentVC()
        vc.groupId = self.groupId
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func CreateToDoList () {
        print("pressed")
        let vc = ToDoListVC()
        vc.groupId = self.groupId
        vc.isTodoCreated = false
        navigationController?.pushViewController(vc, animated: true)
    }
    func CreateNotes() {
        let vc = NotesTableVC()
        vc.groupId = self.groupId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleSend() {
        if self.inputTextField.text == "" {
            return
        }
        guard let message = inputTextField.text else {
            return
        }
        let ref = Database.database().reference().child("Groups").child(groupId!).child("messages")
        
        let childRef = ref.childByAutoId()
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let values = ["text": message, "sender_name": "\((userInfo?.name)!)" , "uid": userID , "date" : getDateTime()]
        childRef.updateChildValues(values) { (error, childRef) in
            if error != nil {
                Utils.showAlert(title: "oops!", message: "\((error!))", presenter: self)
            }
            self.inputTextField.text = ""
        }
       
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
        let userID = Auth.auth().currentUser?.uid
        if allMessages[indexPath.row].uid == userID {
            let cell = tableView.dequeueReusableCell(withIdentifier: "outgoingChatMessageCell") as! OutgoingChatMessageCell
            
            let message = allMessages[indexPath.row]
            cell.senderNameLabel.text = message.sender_name
            cell.timeLabel.text = message.date
            cell.messageText.text = message.text
            cell.selectionStyle = .none
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "incommingChatMessageCell") as! IncommingChatMessageCell
            
            let message = allMessages[indexPath.row]
            cell.senderNameLabel.text = message.sender_name
            cell.timeLabel.text = message.date
            cell.messageText.text = message.text
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var frame = tableView.frame.width * 0.75
        frame = frame - 30
        let size = Utils.calculateTextHeightForTableView(approxWidth: frame, string: allMessages[indexPath.row].text ?? "", fontName: "IBMPlexSans-Light", fontSize: 18)
        return size + 150
    }
}
