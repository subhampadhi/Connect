//
//  GroupsModel.swift
//  Connect
//
//  Created by Subham Padhi on 28/02/19.
//  Copyright © 2019 Subham Padhi. All rights reserved.
//

import Foundation

struct AllGroups : Codable {
    
    var groups : [Groups]?
}

struct Groups: Codable {
    
    var Description : String?
    var Group_Name : String?
    var Members: [String]?
}
