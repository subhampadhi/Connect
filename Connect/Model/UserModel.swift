//
//  UserModel.swift
//  Connect
//
//  Created by Subham Padhi on 28/02/19.
//  Copyright © 2019 Subham Padhi. All rights reserved.
//

import Foundation

struct Users : Codable {
    
    var email : String?
    var name : String?
    var phone : String?
    var groups : [String]?
}
