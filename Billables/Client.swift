//
//  Client.swift
//  Billables
//
//  Created by Theodore Prekop on 8/14/16.
//  Copyright © 2016 Theodore Prekop. All rights reserved.
//

import UIKit

class Client: NSObject, NSCoding{
    
    // MARK: Properties
    let name: String?
    var photo: UIImage?
    var matters: [Matter]
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("clients")
    
    // MARK: Types
    
    struct PropertyKey {
        static let nameKey = "name"
        static let photoKey = "photo"
        static let mattersKey = "matters"
    }
    
    // MARK: Initialization
    
    init?(name: String, photo: UIImage?, matters: [Matter]){
        self.name = name
        self.photo = photo
        self.matters = matters
        
        super.init()
        
        if(name.isEmpty){
            return nil
        }
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(photo, forKey: PropertyKey.photoKey)
        aCoder.encodeObject(matters, forKey: PropertyKey.mattersKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let photo = aDecoder.decodeObjectForKey(PropertyKey.photoKey) as? UIImage
        let matters = aDecoder.decodeObjectForKey(PropertyKey.mattersKey) as! [Matter]
        
        self.init(name: name, photo: photo, matters: matters)
        
    }
    
    
}