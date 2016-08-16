//
//  Matter.swift
//  Billables
//
//  Created by Theodore Prekop on 8/14/16.
//  Copyright © 2016 Theodore Prekop. All rights reserved.
//

import Foundation

class Matter: NSObject, NSCoding{
    
    // MARK: Properties
    
    let client: String?
    var desc: String?
    var time: Double?
    var price: Double?
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("matters")
    
    // MARK: Types
    
    struct PropertyKey {
        static let clientKey = "client"
        static let descKey = "desc"
        static let timeKey = "time"
        static let priceKey = "price"
    }
    
     // MARK: Initialization
    
    init?(client: String, desc: String, time: Double, price: Double){
        self.client = client
        self.desc = desc
        self.time = time
        self.price = price
        
        super.init()
        
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
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        let client = aDecoder.decodeObjectForKey(PropertyKey.clientKey) as! String
        let desc = aDecoder.decodeObjectForKey(PropertyKey.descKey) as! String
        let time = aDecoder.decodeDoubleForKey(PropertyKey.timeKey)
        let price = aDecoder.decodeDoubleForKey(PropertyKey.priceKey)
        
        self.init(client: client, desc: desc, time: time, price: price)
        
    }
}