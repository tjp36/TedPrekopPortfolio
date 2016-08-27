//
//  User.swift
//  Billables
//
//  Created by Theodore Prekop on 8/14/16.
//  Copyright © 2016 Theodore Prekop. All rights reserved.
//

///This singleton is responsible for saving and loading the User Settings

import Foundation

class User : NSObject {
    
    //MARK: - Properties
    var firstName: String?
    var lastName: String?
    var email: String?
    var phoneNumber: String?
    var rate: Double?
    
    static let sharedInstance = User()
    
    private override init(){}
    
    //MARK: - Types
    struct PropertyKey {
        static let firstNameKey = "firstName"
        static let lastNameKey = "lastName"
        static let emailKey = "email"
        static let phoneNumberKey = "phoneNumber"
        static let rateKey = "rate"
    }
    
    // MARK: NSUserDefaults
    func saveValues(){
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(firstName, forKey: PropertyKey.firstNameKey)
        defaults.setObject(lastName, forKey: PropertyKey.lastNameKey)
        defaults.setObject(email, forKey: PropertyKey.emailKey)
        defaults.setObject(phoneNumber, forKey: PropertyKey.phoneNumberKey)
        defaults.setDouble(rate!, forKey: PropertyKey.rateKey)
    }
    
    func loadValues(){
        let defaults = NSUserDefaults.standardUserDefaults()
        firstName = defaults.objectForKey(PropertyKey.firstNameKey) as? String
        lastName = defaults.objectForKey(PropertyKey.lastNameKey) as? String
        email = defaults.objectForKey(PropertyKey.emailKey) as? String
        phoneNumber = defaults.objectForKey(PropertyKey.phoneNumberKey) as? String
        rate = defaults.doubleForKey(PropertyKey.rateKey)
    }
    
}