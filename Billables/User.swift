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
    
    // MARK: Properties
    var firstName: String?
    var lastName: String?
    var email: String?
    var phoneNumber: String?
    var rate: Double?
    
    private init(){
        let aDecoder = NSCoder()
        self.firstName = aDecoder.decodeObjectForKey(PropertyKey.firstNameKey) as? String
        self.lastName = aDecoder.decodeObjectForKey(PropertyKey.lastNameKey) as? String
        self.email = aDecoder.decodeObjectForKey(PropertyKey.emailKey) as? String
        self.phoneNumber = aDecoder.decodeObjectForKey(PropertyKey.phoneNumberKey) as? String
        self.rate = aDecoder.decodeDoubleForKey(PropertyKey.rateKey)
        
    }
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("user")
    
    // MARK: Types
    
    struct PropertyKey {
        static let firstNameKey = "firstName"
        static let lastNameKey = "lastName"
        static let emailKey = "email"
        static let phoneNumberKey = "phoneNumber"
        static let rateKey = "rate"
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(firstName, forKey: PropertyKey.firstNameKey)
        aCoder.encodeObject(lastName, forKey: PropertyKey.lastNameKey)
        aCoder.encodeObject(email, forKey: PropertyKey.emailKey)
        aCoder.encodeObject(phoneNumber, forKey: PropertyKey.phoneNumberKey)
        aCoder.encodeDouble(rate!, forKey: PropertyKey.rateKey)
    }
    
    
}