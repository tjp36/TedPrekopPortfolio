//
//  User.swift
//  Billables
//
//  Created by Theodore Prekop on 8/14/16.
//  Copyright © 2016 Theodore Prekop. All rights reserved.
//

import Foundation

class User{
    static let sharedInstance = User()
    
    var firstName: String?
    var lastName: String?
    var email: String?
    var phoneNumber: String?
    var rate: Double?
    
    private init(){}
    
}