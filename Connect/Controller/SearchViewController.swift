//
//  SearchViewController.swift
//  Connect
//
//  Created by Subham Padhi on 26/02/19.
//  Copyright © 2019 Subham Padhi. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import CodableFirebase

class SearchViewController: UITableViewController , UISearchResultsUpdating {
    
    var groupsList = [Groups]()
    var filteredGroups = [Groups]()
    var isReady = false
    var selectedGroup = Groups()
    let searchController = UISearchController(searchResultsController: nil)
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let quote = "Find Groups"
        navigationItem.title = quote
        tableView.register(SearchResultsCell.self, forCellReuseIdentifier: "searchResultsCell")
        getGroupInfo()
        searchController.searchResultsUpdater = self
        searchController.searchBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredGroups.count
        } else {
            return self.groupsList.count
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filterContent(searchText: self.searchController.searchBar.text!)
    }
    
    func filterContent(searchText:String) {
        self.filteredGroups = self.groupsList.filter({ (groups) in
            let groupName = groups.Group_Name
            return((groupName?.lowercased().contains(searchText.lowercased()))!)
        })
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchController.isActive && searchController.searchBar.text != "" {
            self.selectedGroup = filteredGroups[indexPath.row]
        }else {
            self.selectedGroup = groupsList[indexPath.row]
        }
        let vc = JoinGroupVC()
        vc.hidesBottomBarWhenPushed = true
        vc.groupInfo = self.selectedGroup
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultsCell") as! SearchResultsCell
        
        let group : Groups?
        
        if searchController.isActive && searchController.searchBar.text != "" {
            group = filteredGroups[indexPath.row]
        }else {
            group = groupsList[indexPath.row]
        }
        cell.groupNameLabel.text = group?.Group_Name
        cell.groupDetailsLabel.text = group?.Description
        
        return cell
    }
    
    func getGroupInfo() {
        
        let ref = Database.database().reference()
        ref.child("Groups").queryOrdered(byChild: "Group_Name").observe(.childAdded, with: { (snapshot) in
            guard let value = snapshot.value else { return }
            
            do {
                let model = try FirebaseDecoder().decode(Groups.self, from: value)
                self.groupsList.append(model)
                print(self.groupsList.count)
                
                self.isReady = true
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                print(error)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    
}

class SearchResultsCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        initViews()
    }
    
    var groupNameLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "IBMPlexSans-SemiBoldItalic", size: 16)
        label.textColor = #colorLiteral(red: 0.4078431373, green: 0.1176470588, blue: 0.4392156863, alpha: 1)
        return label
    }()
    
    var groupDetailsLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "IBMPlexSans-Italic", size: 14)
        label.numberOfLines = 2
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        return label
    }()
    
    func initViews() {
        
        addSubview(groupNameLabel)
        addSubview(groupDetailsLabel)
        
        groupNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        groupNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        groupNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 15).isActive = true
        groupNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        
        groupDetailsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        groupDetailsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        groupDetailsLabel.topAnchor.constraint(equalTo: groupNameLabel.bottomAnchor, constant: 10).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
