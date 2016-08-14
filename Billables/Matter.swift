//
//  Matter.swift
//  Billables
//
//  Created by Theodore Prekop on 8/14/16.
//  Copyright © 2016 Theodore Prekop. All rights reserved.
//

import Foundation

class Matter{
    let clientName: String?
    var description: String?
    var time: Double?
    var price: Double?
    
    init(clientName: String){
        self.clientName = clientName
    }
}