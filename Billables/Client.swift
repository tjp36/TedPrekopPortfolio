//
//  Client.swift
//  Billables
//
//  Created by Theodore Prekop on 8/14/16.
//  Copyright © 2016 Theodore Prekop. All rights reserved.
//

import Foundation

class Client{
    let name: String?
    var matters: [Matter] = []
    
    init(name: String){
        self.name = name
    }
}