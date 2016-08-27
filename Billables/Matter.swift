//
//  Matter.swift
//  Billables
//
//  Created by Theodore Prekop on 8/14/16.
//  Copyright © 2016 Theodore Prekop. All rights reserved.
//

///This class defines the Matter object used throughout the application

import Foundation

class Matter: NSObject, NSCoding{
    
    // MARK: Properties
    let client: Client?
    var desc: String?
    var time: Double?
    var price: Double?
    var date: NSDate?
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("clients", isDirectory: true)
    
    // MARK: Types
    struct PropertyKey {
        static let clientKey = "client"
        static let descKey = "desc"
        static let timeKey = "time"
        static let priceKey = "price"
        static let dateKey = "date"
    }
    
    // MARK: Initialization
    init?(client: Client, desc: String, time: Double, price: Double, date: NSDate){
        self.client = client
        self.desc = desc
        self.time = time
        self.price = price
        self.date = date
        
        super.init()
        
        //Prevent matters of duration 0
        if(time.isZero){
            return nil
        }
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        ///Encode for saving
        aCoder.encodeObject(client, forKey: PropertyKey.clientKey)
        aCoder.encodeObject(desc, forKey: PropertyKey.descKey)
        aCoder.encodeDouble(time!, forKey: PropertyKey.timeKey)
        aCoder.encodeDouble(price!, forKey: PropertyKey.priceKey)
        aCoder.encodeObject(date, forKey: PropertyKey.dateKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        let client = aDecoder.decodeObjectForKey(PropertyKey.clientKey) as! Client
        let desc = aDecoder.decodeObjectForKey(PropertyKey.descKey) as! String
        let time = aDecoder.decodeDoubleForKey(PropertyKey.timeKey)
        let price = aDecoder.decodeDoubleForKey(PropertyKey.priceKey)
        let date = aDecoder.decodeObjectForKey(PropertyKey.dateKey) as! NSDate

        self.init(client: client, desc: desc, time: time, price: price, date: date)
    }
}