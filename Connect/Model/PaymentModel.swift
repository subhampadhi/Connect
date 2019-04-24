//
//  PaymentModel.swift
//  Connect
//
//  Created by Subham Padhi on 12/04/19.
//  Copyright © 2019 Subham Padhi. All rights reserved.
//

import Foundation

struct Payment: Codable {
    
    var Capital_To_Raise: String?
    var IS_Target_Set:Bool?
    var Member_ID: String?
    var SecretKey: String?
}
