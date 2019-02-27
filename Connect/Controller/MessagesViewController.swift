//
//  MessagesViewController.swift
//  Connect
//
//  Created by Subham Padhi on 26/02/19.
//  Copyright © 2019 Subham Padhi. All rights reserved.
//

import UIKit
import FirebaseAuth

class MessagesViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        setUpViews()
    }
    
    lazy var messagesTable: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderCell
            cell.addItem = {
                () in
                let vc = CreateGroupVC()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "messagesCell") as! MessagesCell
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
        label.font = label.font.withSize(50)
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
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {}
}
