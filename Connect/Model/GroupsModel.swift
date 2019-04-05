//
//  GroupsModel.swift
//  Connect
//
//  Created by Subham Padhi on 28/02/19.
//  Copyright © 2019 Subham Padhi. All rights reserved.
//

import Foundation

struct Groups: Codable {
    
    var Description : String?
    var Group_Name : String?
    var Members: [String]?
    var Notes : String?
    var TodoList : String?
}
