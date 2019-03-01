//
//  MessagesModel.swift
//  Connect
//
//  Created by Subham Padhi on 01/03/19.
//  Copyright © 2019 Subham Padhi. All rights reserved.
//

import Foundation

struct Messages: Codable {
    
    var date : String?
    var sender_name : String?
    var text: String?
    var uid: String?
}
